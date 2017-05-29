# Chess Application


[![Code Climate](https://codeclimate.com/github/TheCorrespondingSquares/chess-app/badges/gpa.svg)](https://codeclimate.com/github/TheCorrespondingSquares/chess-app)
[![Issue Count](https://codeclimate.com/github/TheCorrespondingSquares/chess-app/badges/issue_count.svg)](https://codeclimate.com/github/TheCorrespondingSquares/chess-app)
[![Test Coverage](https://codeclimate.com/github/TheCorrespondingSquares/chess-app/badges/coverage.svg)](https://codeclimate.com/github/TheCorrespondingSquares/chess-app/coverage)
[![Build Status](https://travis-ci.org/TheCorrespondingSquares/chess-app.svg?branch=master)](https://travis-ci.org/TheCorrespondingSquares/chess-app)
[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

![banner](./public/home.png)




> Chess Application built by The Corresponding Squares Team

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [Maintainers](#maintainers)
- [Contribute](#contribute)
- [License](#license)

## Install

### System Requirements
- Ruby `2.3.1` recommended
- Postgres 9.2+

### Fork and bundle
- Fork the project
- Run bundle to install gems
```bash
bundle install
```

### Database setup

[Download and Install Postgres](https://www.postgresql.org/download/)

- Create the databases:
```bash
rails db:create
```

- Run migrations to create tables:
```bash
rails db:migrate
```

### Running Tests

To run the tests, use:

```bash
bundle exec rspec
```

## Maintainers

Ilya Krasnov _(Lead Engineer/Developer)_ - [https://github.com/ilyakrasnov](https://github.com/ilyakrasnov)

Kirby James _(Engineer/Developer)_ - [https://github.com/kirbygit](https://github.com/kirbygit)

Justin Munn _(Engineer/Developer)_ - [https://github.com/jwmunn](https://github.com/jwmunn)

Nikhil Nadkarny _(Engineer/Developer)_ - [https://github.com/nnadkarny](https://github.com/nnadkarny)

Fisto Satianto _(Engineer/Developer)_ - [https://github.com/fistoriza](https://github.com/fistoriza)

Miguel B. _(Engineer/Developer)_ - [https://github.com/Phatkid98](https://github.com/Phatkid98)

## Contribute



Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## License

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">chess-app</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/TheCorrespondingSquares" property="cc:attributionName" rel="cc:attributionURL">TheCorrespondingSquares</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
