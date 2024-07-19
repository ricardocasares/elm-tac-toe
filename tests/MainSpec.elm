module MainSpec exposing (suite)

import Expect
import Test exposing (Test)


suite : Test
suite =
    Test.describe "Main"
        [ Test.test "It works!" <|
            \_ ->
                True |> Expect.equal True
        ]
