# must run last in setup.sh: plugin installs and mason builds depend on
# brew packages (nvim, node via nvm, tree-sitter, ...)

# install lazy.nvim (bootstrapped by the config itself) and restore all
# plugins to the commits pinned in lazy-lock.json
echo "syncing nvim plugins (Lazy restore)"
nvim --headless "+Lazy! restore" +qa

# refresh mason's package registry, then blocking install + update of
# mason-tool-installer's ensure_installed list (mason has no lockfile,
# so updating to latest is the closest thing to a sync)
echo "updating mason tools"
nvim --headless "+MasonUpdate" +qa
nvim --headless "+MasonToolsUpdateSync" +qa
