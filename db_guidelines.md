# Table design

- *Don't use VARCHAR(n)*
  TEXT is just as fast and efficient

- Follow DasCore principles  
  # TODO: Move this into separate DC doc?  
  All tables should be temporal  
  Create temporal tables by first creating a table named `NAME_current`. Then
  run function `version_table('NAME')`. Afterwards use only table `NAME`.
  Rationale is that it may even be faster and is definitely easier to manage,
  from a "LOC" and also "number of permissions" point of view.

# Style

- Write SQL keywords in uppercase

- Write identifiers in lowercase
  Types also lowercase
