# Unbiased Employee Salary Decision App

Has your company ever been accused of pay inequality between people of different genders, races, disabilities etc?

Even basing an employees salary on their experience and experience could land you in trouble!

Simply pass this app to your employees and let random numbers decide their yearly salary. No more fuss!

# Automation Testing

## Test case style

The test follows the 'Customer Journey' of a typical user. The benefit of this approach is that only valuable tests are written - no writing tests for the sake of tests - only testing valuable customer flows. This requires some careful thinking of how users are likely to interact with the app in an end-to-end fashion as it is detailed in the test comment. This includes the naming of the class and method.

The tests are written in Swift to provide a clean and pleasurable reading and coding experience.

For the purpose of this exercise the tests are contained in one file (for ease of review via Github). To keep the test method clean I have factored out the screen elements, actions and assertions into a separate screen class. 

Within the test method you will find the text that the user will actually see - this copy is not to be hidden in screen classes. This allows the test reader to see exactly what the user will be reading

Assertions are done on UI elements to ensure they exist in the DOM and they are hittable.  This is avoid issues with existing but hidden elements.

In order to ensure the amounts displayed were in range and correctly formatted I have included a range checker and I used a regular expression to assert the currency format with locale of Netherlands Dutch. I've also included a check to ensure numbers are different each time for demonstration purposes.  In order to clearly log which interation of the loop I am in I used XCTest's runActivity method to print to the pretty UI output.

## Executing the test(s)

Test results are displayed using [XCTestHTMLReport](https://github.com/TitouanVanBelle/XCTestHTMLReport) which allows command line run tests to output a html report that looks similar to what you would see inside of Xcode.

1. Install XCTestHTMLReport following the [instructions](XCTestHTMLReport)
2. Run `bundle exec fastlane test_ui` from the command line 

![ios_tests](https://user-images.githubusercontent.com/18099038/89146738-b0768200-d5a8-11ea-8740-9a4b98fa52a5.gif)

## Future work

- [ ] Tear down and recreate simulators for stability
- [ ] Set up Jenkins instance to run as part of CI
