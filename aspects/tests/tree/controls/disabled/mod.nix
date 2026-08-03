{
  _aggregate = false;

  nixos = {
    test.aggregateOwner = true;
  };
}
