this.addEventListener("keypress", (event) => {
  // "n" for next episode
  if (event.key === "n") {
    const nextEpisodeBtn = document.querySelector(
      '[data-testid="UpNextButton"]'
    );
    if (nextEpisodeBtn) nextEpisodeBtn.click();
  }

  // "s" to skip intro
  if (event.key === "s") {
    const nextEpisodeBtn = document.querySelector('[data-testid="SkipButton"]');
    if (nextEpisodeBtn) nextEpisodeBtn.click();
  }
});
