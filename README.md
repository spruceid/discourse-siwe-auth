# Sign-In with Ethereum for Discourse

## Overview
Discourse is an open-source discussion platform used for most crypto governances 
and projects to discuss proposals, updates, and research. The following is a 
quick guide on how to add Sign-In with Ethereum to your existing Discourse.

### Requirements
- A Discourse forum that is self-hosted or that is hosted with a provider that allows 
third party plugins, like [Communiteq](https://www.communiteq.com/).

### Note
The Sign-In with Ethereum plugin still requires users to enter an email to 
associate with their accounts after authenticating for the first time. If the 
user owns an ENS address, it will be the default selected username. Once an 
email address is associated, users can then sign in using the SIWE option at any 
time.

## Enabling the Plugin
To install and enable the plugin on your self-hosted Discourse use the following 
method: Access your container’s app.yml file (present in /var/discourse/containers/)

```bash
cd /var/discourse
nano containers/app.yml
```

Add the plugin’s repository URL to your container’s app.yml file:
```yml
hooks:
  before_code:                             # <-- added
    - exec:                                # <-- added
        cmd:                               # <-- added
          - gem install rubyzip            # <-- added
  after_code:
    - exec:
      cd: $home/plugins
      cmd:
        - sudo -E -u discourse git clone https://github.com/discourse/docker_manager.git
        - sudo -E -u discourse git clone https://github.com/spruceid/discourse-siwe-auth.git   # <-- added
```

Follow the existing format of the docker_manager.git line; if it does not 
contain `sudo -E -u discourse` then insert - `git clone https://github.com/spruceid/discourse-siwe-auth.git`.

Rebuild the container:
```bash
cd /var/discourse
./launcher rebuild app
```
To disable it either remove the plugin or uncheck discourse siwe enabled at 
(Admin Settings -> Plugins -> discourse-siwe -> discourse siwe enabled ).

![Discourse Plugins](/settings.png "Discourse Plugins")
![Enable plugin at settings](/enable.png "Enable plugin at settings")

## Enable WalletConnect
WalletConnect support can be provided via Infura. Create a new Infura project in 
order to receive a new Infura project ID. Then go to the settings (same as before) 
and paste the ID in that location and click on the checkmark. 
![Add infura id to plugin settings](/infura_id.png "Add infura id to plugin settings")

### JSON RPC

As an alternative, you can configure the WalletConnect instance with JSON RPC endpoints, as shown below:

_Doing so will supersede the Infura ID configuration option for WalletConnect specifically, other uses of an Infura ID won't be affected._

![Add JSON RPC endpoints](https://user-images.githubusercontent.com/4248542/170728808-870b441a-b12e-48c2-a47e-939f67aa2739.png)

## Edit the message statement
By default a statement is added to the messages: Sign-in to Discourse via Ethereum. To edit this statement access the settings (same as before) and update it.
![Add infura id to plugin settings](/statement.png "Field related to the message statement")
