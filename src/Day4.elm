module Day4 exposing (Bingo, Board, boardParser, boardsParser, colsBingo, main, numbersParser, parse, puzzleInput, rowParser, rowsBingo, solution1, solution2, solve1, solve2, winner)

import Html exposing (Html)
import List.Extra as List
import Parser exposing ((|.), (|=), Parser, Step(..), Trailing(..), chompWhile, int, loop, succeed)


type alias Bingo =
    { numbers : List Int
    , boards : List Board
    }


type alias Board =
    List (List Int)


solution1 : String -> Int
solution1 input =
    input
        |> parse
        |> solve1


solution2 : String -> Int
solution2 input =
    input
        |> parse
        |> solve2


parse : String -> Bingo
parse string =
    case Parser.run bingoParser string of
        Ok value ->
            value

        Err error ->
            let
                _ =
                    Debug.log "parser error" error
            in
            { numbers = []
            , boards = []
            }


bingoParser : Parser Bingo
bingoParser =
    succeed Bingo
        |= numbersParser
        |= boardsParser


numbersParser : Parser (List Int)
numbersParser =
    succeed identity
        |= Parser.sequence
            { start = "\n"
            , separator = ","
            , end = "\n"
            , spaces = chompWhile (\c -> c == ' ')
            , item = int
            , trailing = Optional
            }


boardsParser : Parser (List Board)
boardsParser =
    succeed identity
        |= Parser.sequence
            { start = "\n"
            , separator = "\n"
            , end = ""
            , spaces = Parser.succeed ()
            , item = boardParser
            , trailing = Parser.Optional
            }


boardParser : Parser (List (List Int))
boardParser =
    loop ( 0, [] ) boardParserHelper
        |> Parser.andThen (\( _, l ) -> succeed l)


boardParserHelper : ( Int, List (List Int) ) -> Parser (Step ( Int, List (List Int) ) ( Int, List (List Int) ))
boardParserHelper ( count, reversedList ) =
    if count < 5 then
        succeed (\row -> Loop ( count + 1, row :: reversedList ))
            |= rowParser

    else
        succeed ()
            |> Parser.map (\_ -> Done ( count, List.reverse reversedList ))


rowParser : Parser (List Int)
rowParser =
    succeed identity
        |= Parser.sequence
            { start = ""
            , separator = ""
            , end = "\n"
            , spaces = chompWhile (\c -> c == ' ')
            , item = int
            , trailing = Parser.Optional
            }


solve1 : Bingo -> Int
solve1 bingo =
    winner bingo 0 |> boardValue



-- Which board can do we the fewest numbers for a bingo?


winner : Bingo -> Int -> ( Board, List Int )
winner bingo pos =
    let
        currentNumbers =
            List.take pos bingo.numbers

        winningBoards =
            List.filter (\b -> hasBingo currentNumbers b) bingo.boards
    in
    case List.head winningBoards of
        Just board ->
            ( board, currentNumbers )

        Nothing ->
            winner bingo (pos + 1)


boardValue : ( Board, List Int ) -> Int
boardValue ( board, marked ) =
    let
        sumUnmarked l =
            List.filter (\n -> not (List.member n marked)) l
                |> List.foldl (+) 0

        unmarkedValue =
            board
                |> List.map (\l -> sumUnmarked l)
                |> List.foldl (+) 0

        lastNumber =
            List.last marked |> Maybe.withDefault 0
    in
    lastNumber * unmarkedValue


hasBingo : List Int -> Board -> Bool
hasBingo numbers board =
    rowsBingo numbers board || colsBingo numbers board 0


rowsBingo : List Int -> List (List Int) -> Bool
rowsBingo numbers rows =
    case rows of
        [] ->
            False

        head :: tail ->
            let
                hits =
                    Debug.log "hits row" <|
                        List.filter (\n -> List.member n numbers) head
            in
            if (hits |> List.length) == List.length head then
                True

            else
                rowsBingo numbers tail


colsBingo : List Int -> List (List Int) -> Int -> Bool
colsBingo numbers rows pos =
    if pos > 4 then
        False

    else
        let
            colValues =
                List.map (List.getAt pos >> Maybe.withDefault 0) rows

            hits =
                Debug.log "hits col" <|
                    List.filter (\n -> List.member n numbers) colValues
        in
        if (hits |> List.length) == List.length colValues then
            True

        else
            colsBingo numbers rows (pos + 1)


solve2 : Bingo -> Int
solve2 bingo =
    4711


main : Html Never
main =
    Html.div []
        [ Html.p []
            [ Html.text (String.fromInt (solution1 puzzleInput))
            ]
        , Html.p [] [ Html.text (String.fromInt (solution2 puzzleInput)) ]
        ]


puzzleInput : String
puzzleInput =
    """
17,25,31,22,79,72,58,47,62,50,30,91,11,63,66,83,33,75,44,18,56,81,32,46,93,13,41,65,14,95,19,38,8,35,52,7,12,70,84,23,4,42,90,60,6,40,97,16,27,86,5,48,54,64,29,67,26,89,99,53,34,0,57,3,92,37,59,9,21,78,51,80,73,82,76,28,88,96,45,69,98,1,2,71,68,49,36,15,55,39,87,77,74,94,61,85,10,43,20,24

36 11 70 77 80
63  3 56 75 28
89 91 27 33 82
53 79 52 96 32
58 14 78 65 38

26 15 50 56  2
20 27 42 11 16
93 44 38 28 68
66 88 78 81 77
91 46 55 86  6

46 53 14 17 75
71  4 70 99 48
65 96 68 80 72
 3 97 62 37 88
82 35 36 23 39

17  1 61 77  5
74 60 12 24 48
34 19 68 65 86
44 59 38 40 95
67 64  9 52 27

44 60  8 81  3
30 71 85 23 99
68 88 38 97 48
27 70 63 28 12
67 57 34 13 93

52 82 88 61  0
68 21 59 75 71
86 36 39 20 48
50 40 19  6 34
93 26 14 41 49

74 18 93 59 77
14 45 57 61 92
10 78 42 63 52
87  3  0 62 20
25 64 48 22 96

11 73 88 47 30
10  6  5 25 67
89 41 62 94 85
45 99 58  7 57
77 19 66 43 48

94 47 45 73 44
22  8 84 79  6
14 58 26 92  5
40 48 42 25  2
37 76 18 80 74

15  3 89 77 98
13 99 10 97 59
18 96 64 47 37
68 92 90 56 11
76 81 12 91 69

82 97 69 47 10
51 12 41 23 45
71  6 67 80 46
31 70 40  9 42
27  1 17 25 74

 2 77  1 37 29
50  8 87 12 76
74 88 48 60 79
41 35 92 33 34
45 52 75 24 28

97 41 49 40 96
84 54 12 24 45
39  1 17 85 52
 3 29 67 33  9
50  7 47 48 81

76 77 15 84 71
41  7 32 29 62
30 87 14 10 48
98 22 96 45  9
66 91 83 21 55

20 42 33  9 91
11 71 64 83 61
82 54 67 38 60
77 57 81 78 98
18  1 27 55 87

 7 13 36 93 47
45 25 44 58 72
74 80 52 24 15
64 43 96 42 20
82 10 73 46 57

40 36 86 87 76
16 11 70 81 25
55 31 83 72 88
57 33 44 58  5
64 15 19 67 53

61 95 27  3 20
85  1 76 25 80
12 78 98 36  4
86 90 19 64 38
22 65 96 87 68

11 52 17 89 64
90 35 94 81 62
65 30 51 67 85
40 32 37 78 74
97 27 10 96 91

45 14 34 23 49
79 21 90 56  4
25 44 92  0 31
16 24 88 48 84
15 63 50 76 52

42 31 84 64 24
34 58 53  3 73
56 35 33 89 41
16  8 85 92  6
40 19 51 14  4

46 61 74 54 30
35 79 63  8 10
64 38 71 23 98
59 72 83 70 50
91 77 69 55 84

93 40  9 49 66
45 35 71 65 61
 5 14 20 83 10
84 47 53 96 97
 6 30 77 52 67

19 78 68 18 86
94 82 16 21 95
71 63 22  3 72
91 27 59 49 11
53 69 46 52 36

44 94 30 21 22
25 81 60 74 99
32 62 10 79 39
28 63 96 90 55
58 85 93 36 76

90 71 76 51 87
26 64  2 49 19
54 47 32 93 92
88 69 24 60 94
42 73 67 56 23

 8 22 47 12 10
59 31 99 41 17
60 23 37  0 57
21 11 77 79 91
50 34 16 72 15

27 11 12  7 83
 9 50 47 84 35
75 99 97 78 53
20 70 51 76 44
73 90  0 62 58

60 49  0 40  8
74 73 95  3 90
27 39 10 19 35
 6 50 16 72 82
71 36 11 99 52

15 97  9 75 37
33 65 30 18 10
93 14 77 80 36
82 35 88 12 21
40 22 84 49 81

18 74 94 79 17
39 51 98  8 99
33 63 50 65 40
29 55 75 91 90
24 54 87 97 48

44 81 21 77 10
 8 52 54  5 88
37 29 59 43 34
70 30 86 31 56
35 40 13  4 45

12 84 38 37 54
72 69 86 90 91
31 45 15 52 59
51  9  1 34 63
53 29 20  3 56

43 46 86 35 73
94 87 90 39 95
25  0 17 84 54
22 27 76 26 63
91 68  2 14 37

67 63 20 21 27
98 78  4 51 82
74 86 46 12 56
57 94 81 33 11
29 13 83 37 40

11 87 71 33 64
52 97 91 79 24
54 37 72 55  0
21 67 80 51 10
 6 35 49 68 18

27  7 95 81 93
99 97 67 65 72
59 92 32 43 50
56 74 42 75 41
13 36 79 78 23

94  9 47 30 85
 5 80 86 55 11
44 54 17 74 36
22 98 84  7 88
52 34  0 97 73

10 70 26 89 28
98 41 77 64 38
46  8 22  5 29
71 11 57 20 31
97 90 50 95 51

26 23 73 25 11
80 97 68  7 27
43 72 47 49 93
 2 21 50 82 66
34 81 90 18 48

79 61 33 42 50
28 44 30 99 88
57 14 35 60 31
15 27 34 13 19
72 71 64 76 21

80 73 78 18 28
79  1 76 42 58
90 85 48 81 61
52 44 51 53 39
63 98 25 24 70

22 63 35 31 11
55 48 85 65 68
49 52 40 74 97
37 69 98 79 67
 2 91  7 41 16

28 43 21 66 67
56 88 77 37 41
63 55 79 94 62
61 60 23 45 87
58 12 99 47 73

 2 21 26 27 42
65 47 71 85  4
76 13 40 56 29
50 53 28 97 90
17  1 14 74 48

 4 98 39 40 11
90 88 87 86 13
92 80 95 99 51
54 18 70 34 38
75 37 28 78 46

 7 11 73 51 47
26 69 61 91 57
55 48 14 94 82
19 37 15 54 65
25 43 90 16 81

50 30 78  7 61
99 32 91 13 21
 5 27 11 92 73
71 54 29 20 12
 8 75 65  9 39

84 13 22 90  7
64  6 21  3 23
 8 72 67 61 62
44 32 20 25 45
57 81 49 98 77

12  9 53 94  8
85  0 70 35 82
90 67 48 79 54
26 88 51  2 46
78 63 61 36 29

86 27 13 55 37
67 61 39  1 66
79 97 40 42  7
64 85 33 31 46
34 65 24 54 50

 8 58 80 35 47
31 66 45 36 54
 9 27 64 16  5
34 14 10 57 85
40 79 60 61  3

49 31  2 25  9
34 65 14 54 61
88 28 45  3 76
 7 94 24  1 86
29 66 70 96 50

72 35 31 84 37
 8 86  4 17 46
39 80 43 11  3
26 76 44 20 95
71  5 51 65 32

98 33  8 41 75
94 49 27 95 72
44 18 82  0 90
86 74  2 59 45
20 57 25 87 42

64 72 33 23 96
70  2 68 97 69
59 49 19 35 10
87 92 85 34 90
56 95 88 66 94

97 23 75 47 43
32 19 69 29 94
45 38 61  4 40
26 82 30 16  2
95 76  5 67 83

 4 75 91 82 23
52 38 47 49 46
97 17  6 90 59
 8 16 12 73 85
88 64 32 99 11

 2 61 15  7 37
45 57 43 46 92
76 99 34 14  9
51  8 18 81 50
19 47 97 29 26

70 61 79 67 17
25 69 78  4 24
87 11 95 68 91
51 89 39 66 80
29 98 43 64 86

95 40 97 32 48
44  0 64 45 83
34 88 20 86 31
84 16 96 78 65
 2 81 72 69 43

98 88 93  3 10
53 72 68 81 62
56 38 36 87 27
29 99 76 28 23
16 59 71 21 92

95 17  8  7 46
71 61  5 90 38
63 65 25 45 22
11 16 93 34 14
55 56 36 91 49

61 36  9 12 40
60 51 57 41 87
35 97 75 20 21
74 34 19 14 95
84 68 98 62  0

 3  5 57 40 61
30 79 94 86 84
20  9 13 27 34
59 98 17 12 14
28 73 18 97 75

 3 86 99 48  2
65 97 26 82 79
51 16 70  7 89
22 83 50 78 32
31 72 28 21 60

67 27 78 91 14
21  4 20 42 62
52  3 36 17 18
 6 40 46 39 63
80 75 54 96 99

89 77 18 59 99
 5 55 14 52 12
91 70 85 16 24
72 42 80 81 76
46 95 37 23 11

48 66 23 26 15
16 76 81 10 49
57 74 68 67 98
43 31 53 94 86
80 71 85  0 33

95 69 45 80 35
38 88 62 28  1
44 10 91 39 31
74 81 64 63 98
33 13 89 53 56

85 22 55 95 44
93  9 58 11 27
15 40  2 28 87
 5 84 77 48 42
94 18 16 12 79

69 74 75 16 77
45 56 60 81 68
33 73 49 14 92
94 51 24 38 15
90 10 89  6 32

15 86 73 20 71
 7 33 47 36 96
31 55 87 22 14
13 35  8 77 89
 3 37 98 52 34

92 79 95 74 85
19  3  5 73 67
93 41 81 78 77
48 88 57 82 15
36 38 42  4 69

87 36 38 65 91
18 47 41 66 35
 0 63 59 54 10
44  1 37 81 48
75 96 42  4 25

14 19 63  8 36
35 38 84 66 42
99  7 70 74  6
 4 12 86 65 22
46 40 60 31 80

38 29 26 65 85
21  6 15 77 14
61 25 86 12 35
71 67 74 59 42
46 52 30 19 93

10 61 18 67 26
15 27 20 62 38
58 24 28 45 90
98 39 59  3 92
64 35 60 68 19

34 44 11 25 56
 2 63  5 94 76
72 92  0 27 84
60  8 80 48 90
23  7 75 70 47

78 18 19 34 39
31 66 95  9 36
64 99 57 94 75
29 97 51 45 47
93 79 23 84 24

72 23 78 90 21
41 67 31  4 57
34 58 50 46 74
55 37 81 63 45
85  8 48 28 12

18 30 28 50 81
67 47 41 45 59
51 14 92  6 68
 8 46 69 84 13
93 25 58 26 75

76 16 78 36 18
 3  7 28 73 41
34 97 42 23  8
 9 67 49 83 64
81  5 29 85 79

 3 35 80 53  5
91 96 77 52 69
44 32  4 60 26
41 13 28 39 64
73 27 34 71 92

72  4 77 80 29
32 36 70 47 79
96 56 69  2 90
13 20 24 81 67
23 25 83 89 91

32 46 88 81 75
 5 98 15 72 31
56 89 90 21 16
37  2 82 93 18
63 52 49 19 41

52 51 76 91 33
29 37 32 43 42
27 34 21 72 87
62 64  8 73 41
23 46 67 96 85

82 19  5 88 54
71 27 92 48 16
25 96 40 56 37
41 11 26 58 95
63 17  1  0 24

46 36 85 78 32
55 50 94  9 57
 0 20 24 68 28
52 22  3 84 17
16  2  1 66 69

14 87 83 79 36
 9 64 77 49 24
25 92  5 62 91
73 33 74  6 65
39  2 59 71 50

99  0 48 98 45
50 27 92  8 73
91 80 54 42 57
18 78 55 19 36
76 28 53  6  7

29 68 27 95 47
40 32 79 60  2
44 53 57  6 25
41 56 66 30 77
26 13 83 23 51

 7 76 59 44 22
81 15 48  8 47
77 79 32 61 39
65 29 95 35 45
 1  6 13  9  3

 3 52 93 20 70
49 80 40 66 53
 2 71 41  1 13
44 24 15 83  0
14 17  7 56 63

77 12 99 19 21
62 63 98 56 66
28  4 22 68 55
49 65 96 84 57
41 74 46 60 53

64  7 16  8 38
55 68 21 43 99
92  0 79 35 96
75 28 51 87 53
57 73 84 18  3

95 90 17 40 51
46 12 23 91 38
80 10 68  9 93
65 69 49 27 66
94  4 39 97 31

 4 64 39  3 33
26 88 10 96 54
21 48  7 78 50
22 90 16 15 72
92  2 71 70 68

42 26 72 54 41
97 94 80 47 63
19 24 90 78  6
48 34 50 98 89
33 81 66 38 10

65 24 23  1 19
54 35 76 71 49
10 75 99 91 97
21 78 17 18 81
 3 48 72  7 96
    """
