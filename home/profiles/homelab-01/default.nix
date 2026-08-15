{
  self,
  mylib,
  ...
}: {
  imports = map mylib.relativeToRoot [
    "home/programs"
  ];
}
