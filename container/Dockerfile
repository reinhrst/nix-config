FROM ubuntu:24.04@sha256:59a458b76b4e8896031cd559576eac7d6cb53a69b38ba819fb26518536368d86

# Install base dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends\
        ca-certificates=20240203 \
        curl=8.5.0-2ubuntu10.6 \
        xz-utils=5.6.1+really5.4.5-1ubuntu0.2 \
        git=1:2.43.0-1ubuntu7.3 && \
    rm -rf /var/lib/apt/lists/*

# Create user and directories
RUN useradd -m -s /bin/bash reinoud && \
    mkdir -p /nix && \
    chown -R reinoud:reinoud /nix && \
    chown -R reinoud:reinoud /home/reinoud

# Copy nix configuration files (build context is parent dir)
COPY --chown=reinoud:reinoud flake.nix flake.lock home.nix /home/reinoud/nix-config/
COPY --chown=reinoud:reinoud modules/ /home/reinoud/nix-config/modules/

# Install Nix, home-manager, and configure in one layer to minimize image size
RUN su - reinoud -c 'curl -L https://releases.nixos.org/nix/nix-2.32.1/install | sh -s -- --no-daemon' && \
    mkdir -p /home/reinoud/.config/nix && \
    echo "experimental-features = nix-command flakes" > /home/reinoud/.config/nix/nix.conf && \
    chown -R reinoud:reinoud /home/reinoud/.config && \
    su - reinoud -c '. /home/reinoud/.nix-profile/etc/profile.d/nix.sh && \
        cd /home/reinoud/nix-config && \
        nix run github:nix-community/home-manager/release-24.11 -- switch --flake .#reinoud@docker && \
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
