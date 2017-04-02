# Week 1 Project: Flicks

**MovieViewer** is a movies app using the [The Movie Database API]()(http://docs.themoviedb.apiary.io/#).

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x]() User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x]() User can view movie details by tapping on a cell.
- [x]() User sees loading state while waiting for the API.
- [x]() User sees an error message when there is a network error.
- [x]() User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x]() Add a tab bar for **Now Playing** and **Top Rated** movies.
- [x]() Implement segmented control to switch between list view and grid view.
- [x]() Add a search bar.
- [ ]() All images fade in.
- [ ]() For the large poster, load the low-res image first, switch to high-res when complete.
- [x]() Customize the highlight and selection effect of the cell.
- [x]() Customize the navigation bar.

The following **additional** features are implemented:

- [x]() Refactored the code to use a struct to store movie data, parse JSON in the struct and store movie details as array of structs 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

\<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' /\>

GIF created with [LiceCap]()(http://www.cockos.com/licecap/).

## Notes

1. It was difficult to change the color of the small icons located in the search bar. Could not find any appropriate properties in the API documentation. Found more complex solution on [http://stackoverflow.com/ ][16] The solution works for the small magnifying glass but does not work for the cancel button.
2. Noticed that table view cell gets unpleasant gray color for a moment when clicked. Spent some time searching for solution in API documentation. Then realized that the solution was provided in the CodePath assignment description. Lesson learnt - read the assignment first :-)

## License

Copyright [2017]() [Wieniek]()

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[16]:	http://stackoverflow.com/
