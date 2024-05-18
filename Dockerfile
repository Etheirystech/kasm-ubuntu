FROM kasmweb/ubuntu-focal-desktop:1.15.0-rolling

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Update and upgrade the package list
RUN apt-get update && apt-get -y upgrade

# Install curl for downloading scripts and other essential tools
RUN apt-get install -y curl software-properties-common

# Install NVM (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Use a login shell to source nvm properly and install Node.js
RUN /bin/bash -c "source ~/.nvm/nvm.sh && nvm install 20"

# Add the GitHub CLI repository and key
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Update package list and install Python, pip, and GitHub CLI
RUN apt-get update && apt-get install -y python3 python3-pip gh

# Create the necessary directories and add alias for 'py' to .bashrc
RUN echo "alias py='python3'" >> /home/kasm-default-profile/.bashrc




# Verify installations (Optional: Uncomment if needed for debugging)
# RUN python3 --version && pip3 --version && gh --version

# Change Background to sth cool
#COPY assets/mr-robot-wallpaper.png  /usr/share/extra/backgrounds/bg_default.png

# Install Starship
#RUN wget https://starship.rs/install.sh
#RUN chmod +x install.sh
#RUN ./install.sh -y

# Add Starship to bashrc
#RUN echo 'eval "$(starship init bash)"' >> .bashrc

# Add Starship Theme
#COPY config/starship.toml .config/starship.toml

# Install Hack Nerd Font
RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
RUN unzip Hack.zip -d /usr/local/share/fonts

# Install XFCE Dark Theme
RUN apt install numix-gtk-theme


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

######### VSCode Customization ###########
# Copy VS Code settings
COPY vscode/settings.json /home/kasm-default-profile/.config/Code/User/settings.json

# Copy extensions list and install extensions
COPY vscode/extensions.txt /tmp/extensions.txt
RUN cat /tmp/extensions.txt | xargs -L 1 code --install-extension

## Copy disabled extensions list
#COPY vscode/disabled_extensions.txt /tmp/disabled_extensions.txt
#
## Disable specific extensions
#RUN cat /tmp/disabled_extensions.txt | xargs -L 1 code --disable-extension
