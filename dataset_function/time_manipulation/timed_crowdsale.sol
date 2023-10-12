









  function isSaleFinished() view public returns (bool) {
    // <yes> <report> TIME_MANIPULATION
    return block.timestamp >= 1546300800;
  }
