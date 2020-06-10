# Minoa

## Install & Run

### Common

* clone this repository
* `cd minoa`
* `mix setup`

### Production

* `MIX_ENV=prod mix compile`
* `npm run deploy --prefix ./assets`
* `mix phx.digest && export SECRET_KEY_BASE=$(mix phx.gen.secret) && MIX_ENV=prod mix phx.server`

### Development

* `mix phx.server`

## Testing

* `mix test`

N.B.:

* Formatting: `mix format` has been run
* I'd look at removing parens where possible/clearer
* local variables have been avoided in many places, but in a couple this results in the same function call multiple times; I'd look into if this is a performance problem and/or is it really cleaner
* I'd change the name "maze" to "board"
* some functions could be renamed for clarity
* even though variable names are long and descriptive, more comments and module docs would be better
