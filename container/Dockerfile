FROM ubuntu:latest

# Install base dependencies
RUN apt-get update && \
    apt-get install -y sudo curl xz-utils git && \
    rm -rf /var/lib/apt/lists/*

# Create user and directories
RUN useradd -m -s /bin/bash reinoud && \
    mkdir -p /nix && \
    chown -R reinoud:reinoud /nix && \
    chown -R reinoud:reinoud /home/reinoud

# Add reinoud to sudoers without password
RUN echo "reinoud ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 440 /etc/sudoers

# Copy nix configuration files (build context is parent dir)
COPY --chown=reinoud:reinoud flake.nix flake.lock home.nix /home/reinoud/nix-config/
COPY --chown=reinoud:reinoud modules/ /home/reinoud/nix-config/modules/

# Install Nix, home-manager, and configure in one layer to minimize image size
RUN sudo -u reinoud bash -lc 'curl -L https://nixos.org/nix/install | sh -s -- --no-daemon' && \
    mkdir -p /home/reinoud/.config/nix && \
    echo "experimental-features = nix-command flakes" > /home/reinoud/.config/nix/nix.conf && \
    chown -R reinoud:reinoud /home/reinoud/.config && \
    sudo -u reinoud bash -lc '. /home/reinoud/.nix-profile/etc/profile.d/nix.sh && \
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && \
        nix-channel --update && \
        nix-shell "<home-manager>" -A install && \
        cd /home/reinoud/nix-config && \
        home-manager switch --flake .#reinoud@docker && \
        nix-collect-garbage -d && \
        nix-store --gc && \
        nix-store --optimize' && \
    rm -rf /home/reinoud/.cache && \
    rm -rf /tmp/* && \
    rm -rf /home/reinoud/nix-config

# Switch to reinoud user
USER reinoud
WORKDIR /home/reinoud
ENV USER=reinoud

# Default shell
CMD ["/home/reinoud/.nix-profile/bin/zsh", "-l"]
