document.addEventListener('DOMContentLoaded', async () => {
  const getCSRF = () => {
    return document.querySelector('meta[name="csrf-token"]').content;
  };

  const env = await fetch('/siwe/modal_config', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': getCSRF(),
    },
    credentials: 'include',
  }).then(res => res.json());

  const getPath = (path) => {
    return env.prefix ? `/${env.prefix}/${path}` : `${path}`;
  };

  const Web3Modal = window.Web3Modal.default;

  const providerOptions = (() => {
    const opt = {};
    try {
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
            logo: '/plugins/discourse-siwe-auth/images/siwe/coinbase.svg',
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
    } catch (err) {
      console.log(err);
    }
    return opt;
  })();

  const web3Modal = new Web3Modal({
    network: env.network,
    cacheProvider: true,
    providerOptions,
  });

  const button = document.getElementById('siwe');

  button.addEventListener('click', async (e) => {
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

    const message = await fetch(getPath('message'),
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

    fetch(getPath('signature'), {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRF(),
      },
      credentials: 'include',
      body: JSON.stringify({ signature, ens }),
    })
      .then(res => res.json())
      .then(({ ens, address }) => {
        let params = new URLSearchParams(window.location.search);
        let redirect = new URL(`${window.location.origin}${params.get('redirect_url') || '/'}`);
        redirect.searchParams.append('ens', ens);
        redirect.searchParams.append('address', address.toLowerCase());
        window.location.href = redirect.toString();
      });
  });
});
