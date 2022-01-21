import loadScript from "discourse/lib/load-script";
import { withPluginApi } from "discourse/lib/plugin-api";

function loadWeb3Bundle() {
  return loadScript(
    "/plugins/discourse-siwe-auth/javascripts/web3bundle.min.js"
  );
}

function initializePlugin(api) {
  const siteSettings = api.container.lookup("site-settings:main");

  const Web3Modal = window.Web3Modal.default;

  const env = {
    prefix: siteSettings.siwe_prefix,
    network: siteSettings.siwe_network,
    INFURA_ID: siteSettings.siwe_infura_id,
    TORUS: siteSettings.siwe_torus,
    PORTIS_ID: siteSettings.siwe_portis_id,
    FORTMATIC_KEY: siteSettings.siwe_fortmatic_key,
    COINBASE: siteSettings.siwe_coinbase,
  };

  const providerOptions = (() => {
    const opt = {};

    if (env.INFURA_ID) {
      opt.walletconnect = {
        package: Web3Bundle.WalletConnectProvider,
        options: {
          infuraId: env.INFURA_ID,
          pollingInterval: 100000,
        }
      };
    }

    if (env.TORUS) {
      opt.torus = {
        package: Web3Bundle.Torus,
      };
    }

    if (env.PORTIS_ID) {
      opt.portis = {
        package: Web3Bundle.Portis,
        options: {
          id: env.PORTIS_ID,
        },
      };
    }

    if (env.FORTMATIC_KEY) {
      opt.fortmatic = {
        package: Web3Bundle.Fortmatic,
        options: {
          key: env.FORTMATIC_KEY,
        },
      };
    }

    if (env.COINBASE && env.INFURA_ID) {
      opt['custom-coinbase'] = {
        display: {
          logo: '<%= asset_path "siwe_rails/coinbase.svg" %>',
          name: 'Coinbase',
          description: 'Scan with WalletLink to connect',
        },
        options: {
          appName: 'Sign-In with Ethereum',
          networkUrl: `https://${env.network}.infura.io/v3/${env.INFURA_ID}`,
          chainId: 1,
          darkMode: false,
        },
        package: Web3Bundle.WalletLink,
        connector: async (_, options) => {
          const { appName, networkUrl, chainId, darkMode } = options;
          const walletLink = new Web3Bundle.WalletLink({
            appName,
            darkMode,
          });
          const provider = walletLink.makeWeb3Provider(networkUrl, chainId);
          await provider.enable();
          return provider;
        },
      };
    }

    return opt;
  })();

  const getCSRF = () => {
    return document.querySelector('meta[name="csrf-token"]').content;
  };

  const signIn = async () => {
    const walletProvider = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(walletProvider);

    const [address] = await provider.listAccounts();
    if (!address) {
      throw new Error('Address not found.');
    }

    let ens;
    try {
      ens = await provider.lookupAddress(address);
    } catch (error) {
      console.error(error);
    }

    let { chainId } = await provider.getNetwork();

    const message = await fetch(`${env.prefix}/message`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': getCSRF(),
        },
        credentials: 'include',
        body: JSON.stringify({
          chainId,
          address,
        })
      }).then((res) => res.text());

    const signature = await provider.getSigner().signMessage(message);

    fetch(`${env.prefix}/signature`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRF(),
      },
      credentials: 'include',
      body: JSON.stringify({ signature, ens }),
    }).then(async (res) => {
        // TODO redirect to proper route
        console.log(res);
        window.location.href = '/';
      });
  };

  const web3Modal = new Web3Modal({
    network: env.network,
    cacheProvider: true,
    providerOptions,
  });

  api.onPageChange((url, title) => {
    $(document).on('click', '.btn-social.siwe', function(e){
      e.preventDefault();
      signIn();
    });
  });
}

export default {
  name: 'discourse-siwe-auth',
  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    if (siteSettings.siwe_enabled) {
      withPluginApi("0.8.22", initializePlugin);
    }
  },
}
