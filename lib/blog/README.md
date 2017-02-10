# Storing Schemas

Phoenix 1.3 encourages you to have multiple schemas pointing to the same
database table.

These schemas are supposed to be named after the context module where they are
used. For example, you might have an "Accounts" context module, where all the
business logic for managing accounts is. Your schemas would live in 
`lib/account/schema_name.ex`, along with any other modules having to do with
accounts.

In this app, we only have one context: `Blog`, so the schemas are all in the
`lib/blog` folder.

However, **it's often overly-complicated to have multiple schemas pointing to
the same database table.** Don't do it blindly. A simpler way to do things is
just to create a `lib/schemas` folder and put them all in there.

The average application can get away with a structure like this:

```
lib/
  schemas/
    ...shared schemas
  accounts/
    ...modules
  other_context/
    ...modules
  account.ex
  other_context.ex
```
