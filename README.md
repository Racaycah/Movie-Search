# Movie-Search

## Running The Project
Clone the project and run it in a simulator of your choice.

> **iPad not tested**

## About The Project

- MVVM is used for the architecture.
- I wanted to try out Combine.
- The usual networking pattern I use is improved a bit (separated calls for enum cases with the request method kept private, eliminating redundant `decodingTo: T.Type` parameter).

- Search for a movie title and results will load after half a second of debounce.
- Empty input, empty results and errors are handled in search screen.
- There is a basic movie details screen, TMDB page of the movie can be opened with the right bar button.

- Inspiration for design is from [MovieSwiftUI](https://github.com/Dimillian/MovieSwiftUI). Even though I didn't use SwiftUI, I wanted to check it out since it's one of the first large scale apps developed with SwiftUI since its release and a fully-developed version of this project.

### Known Issues

- There are 3 `TODO`s in the project, 2 of which are about saving and loading the `WATCHED` state of movies and one about pagination.
- `Watched / Not Watched` buttons do not look good with their current width.
- `RatingView` was supposed to be used to display the overall rating of a movie in details screen, but I couldn't make it draw like I wanted and didn't want to waste too much time trying to fix.
