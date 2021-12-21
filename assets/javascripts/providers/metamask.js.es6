import ethers from 'ethers';

export default {
    name: 'bind-to-metamask',
    initialize() {
        const metamask = window.ethereum;
        let provider;
        const signIn = async (connector) => {
            /**
             * Connects to the wallet and starts a etherjs provider.
             */
            if (connector === 'metamask') {
                await metamask.request({
                    method: 'eth_requestAccounts',
                });
                provider = new ethers.providers.Web3Provider(metamask);
            }

            const [address] = await provider.listAccounts();
            if (!address) {
                throw new Error('Address not found.');
            }

            /**
             * Try to resolve address ENS and updates the title accordingly.
             */
            let ens;
            try {
                ens = await provider.lookupAddress(address);
            } catch (error) {
                console.error(error);
            }

            let { chainId } = await provider.getNetwork();

            /**
             * Gets the proper message from our backend
             */
            const message = await fetch('/siwe/message',
                {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    credentials: 'include',
                    body: JSON.stringify({
                        chainId,
                        address,
                    })
                }).then((res) => res.text());

            /**
             * Asks for the provider to sign our fresh message
             */
            const signature = await provider.getSigner().signMessage(message);

            /**
             * Calls our sign_in endpoint to validate the message, if successful it will
             * save the message in the session and allow the user to store his text
             */
            fetch(`/api/sign_in`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                credentials: 'include',
                body: JSON.stringify({ signature, ens }),
            }).then(async (res) => {
                if (res.status === 200) {
                    res.json().then(({ text, address, ens }) => {
                        connectedState(text, address, ens);
                        return;
                    });
                } else {
                    res.json().then((err) => {
                        console.error(err);
                    });
                }
            });
        };

        /**
         * Bellow here are just helper functions to manage app state
         */
        let metamaskButton = document.getElementById('metamask');
        /**
         * If we don't have metamask installed hide the button.
         */
        if (typeof metamask === undefined) {
            metamaskButton.classList.add('hidden');
        }

        metamaskButton.addEventListener('click', () => signIn("metamask"));
    }
}