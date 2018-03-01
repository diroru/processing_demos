class MigrationRelation {
  Country origin, destination;

  MigrationRelation (Country o, Country d) {
    origin = o;
    destination = d;
  }

  @Override
  public boolean equals(Object obj) {
    if (!(obj instanceof MigrationRelation)) {
      return false;
    }
    MigrationRelation mr = ((MigrationRelation) obj);
    return this.origin.equals(mr.origin) && this.destination.equals(mr.destination);
  }

  @Override
  public int hashCode() {
     return Objects.hash(origin, destination);
  }
  
  @Override
  String toString() {
    return origin.name + " -> " + destination.name;
  }
}