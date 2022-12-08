module Day15Test exposing (parsedTestInput, suite, testInput)

import Array
import Day15 exposing (NodeState(..))
import Expect exposing (Expectation)
import Matrix exposing (Matrix)
import Set
import Test exposing (..)


suite : Test
suite =
    describe "Day15"
        [ describe "Problem 1"
            [ test "nextState 1" <|
                \_ ->
                    Day15.nextState miniState
                        |> Expect.equal expectedStep1
            , test "Small example" <|
                \_ ->
                    Day15.loopUntilGoal ( 0, 0, 0 ) (Day15.Point 2 3) miniState
                        |> Expect.equal 13
            , test "Parser" <|
                \_ -> Day15.parse testInput |> Expect.equal parsedTestInput
            , test "As given" <|
                \_ -> Day15.solution1 testInput |> Expect.equal 40
            , test "From puzzle input" <|
                \_ -> Day15.solution1 Day15.puzzleInput |> Expect.equal 790
            ]
        , describe "Problem 2"
            [ test "Increase grid 5 times" <|
                \_ ->
                    Day15.increaseBy5 (Day15.parse testInput)
                        |> Expect.equal (Day15.parse testInput2)
            , test "As given" <|
                \_ -> Day15.solution2 testInput |> Expect.equal 315
            , test "From puzzle input" <|
                \_ -> Day15.solution2 Day15.puzzleInput |> Expect.equal 2998
            ]
        ]


miniState : Day15.State
miniState =
    { cave = miniCave
    , currentNode = ( 0, 0, 0 )
    , unvisited = Set.empty
    }


miniCave : Matrix Day15.NodeState
miniCave =
    Array.fromList
        [ Array.fromList [ Visited 1, Initial 2, Initial 6, Initial 3 ]
        , Array.fromList [ Initial 1, Initial 3, Initial 8, Initial 1 ]
        , Array.fromList [ Initial 2, Initial 1, Initial 3, Initial 6 ]
        ]


expectedStep1 : Day15.State
expectedStep1 =
    { cave =
        Array.fromList
            [ Array.fromList [ Visited 1, UnvisitedState { risk = 2, value = 2 }, Initial 6, Initial 3 ]
            , Array.fromList [ UnvisitedState { risk = 1, value = 1 }, Initial 3, Initial 8, Initial 1 ]
            , Array.fromList [ Initial 2, Initial 1, Initial 3, Initial 6 ]
            ]
    , currentNode = ( 0, 0, 0 )
    , unvisited = Set.fromList [ ( 0, 1, 2 ), ( 1, 0, 1 ) ]
    }


testInput =
    """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""


parsedTestInput : Matrix NodeState
parsedTestInput =
    Array.fromList
        [ Array.fromList [ Initial 1, Initial 1, Initial 6, Initial 3, Initial 7, Initial 5, Initial 1, Initial 7, Initial 4, Initial 2 ]
        , Array.fromList [ Initial 1, Initial 3, Initial 8, Initial 1, Initial 3, Initial 7, Initial 3, Initial 6, Initial 7, Initial 2 ]
        , Array.fromList [ Initial 2, Initial 1, Initial 3, Initial 6, Initial 5, Initial 1, Initial 1, Initial 3, Initial 2, Initial 8 ]
        , Array.fromList [ Initial 3, Initial 6, Initial 9, Initial 4, Initial 9, Initial 3, Initial 1, Initial 5, Initial 6, Initial 9 ]
        , Array.fromList [ Initial 7, Initial 4, Initial 6, Initial 3, Initial 4, Initial 1, Initial 7, Initial 1, Initial 1, Initial 1 ]
        , Array.fromList [ Initial 1, Initial 3, Initial 1, Initial 9, Initial 1, Initial 2, Initial 8, Initial 1, Initial 3, Initial 7 ]
        , Array.fromList [ Initial 1, Initial 3, Initial 5, Initial 9, Initial 9, Initial 1, Initial 2, Initial 4, Initial 2, Initial 1 ]
        , Array.fromList [ Initial 3, Initial 1, Initial 2, Initial 5, Initial 4, Initial 2, Initial 1, Initial 6, Initial 3, Initial 9 ]
        , Array.fromList [ Initial 1, Initial 2, Initial 9, Initial 3, Initial 1, Initial 3, Initial 8, Initial 5, Initial 2, Initial 1 ]
        , Array.fromList [ Initial 2, Initial 3, Initial 1, Initial 1, Initial 9, Initial 4, Initial 4, Initial 5, Initial 8, Initial 1 ]
        ]


testInput2 =
    """
11637517422274862853338597396444961841755517295286
13813736722492484783351359589446246169155735727126
21365113283247622439435873354154698446526571955763
36949315694715142671582625378269373648937148475914
74634171118574528222968563933317967414442817852555
13191281372421239248353234135946434524615754563572
13599124212461123532357223464346833457545794456865
31254216394236532741534764385264587549637569865174
12931385212314249632342535174345364628545647573965
23119445813422155692453326671356443778246755488935
22748628533385973964449618417555172952866628316397
24924847833513595894462461691557357271266846838237
32476224394358733541546984465265719557637682166874
47151426715826253782693736489371484759148259586125
85745282229685639333179674144428178525553928963666
24212392483532341359464345246157545635726865674683
24611235323572234643468334575457944568656815567976
42365327415347643852645875496375698651748671976285
23142496323425351743453646285456475739656758684176
34221556924533266713564437782467554889357866599146
33859739644496184175551729528666283163977739427418
35135958944624616915573572712668468382377957949348
43587335415469844652657195576376821668748793277985
58262537826937364893714847591482595861259361697236
96856393331796741444281785255539289636664139174777
35323413594643452461575456357268656746837976785794
35722346434683345754579445686568155679767926678187
53476438526458754963756986517486719762859782187396
34253517434536462854564757396567586841767869795287
45332667135644377824675548893578665991468977611257
44961841755517295286662831639777394274188841538529
46246169155735727126684683823779579493488168151459
54698446526571955763768216687487932779859814388196
69373648937148475914825958612593616972361472718347
17967414442817852555392896366641391747775241285888
46434524615754563572686567468379767857948187896815
46833457545794456865681556797679266781878137789298
64587549637569865174867197628597821873961893298417
45364628545647573965675868417678697952878971816398
56443778246755488935786659914689776112579188722368
55172952866628316397773942741888415385299952649631
57357271266846838237795794934881681514599279262561
65719557637682166874879327798598143881961925499217
71484759148259586125936169723614727183472583829458
28178525553928963666413917477752412858886352396999
57545635726865674683797678579481878968159298917926
57944568656815567976792667818781377892989248891319
75698651748671976285978218739618932984172914319528
56475739656758684176786979528789718163989182927419
67554889357866599146897761125791887223681299833479
    """
