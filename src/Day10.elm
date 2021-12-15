module Day10 exposing
    ( autocomplete
    , chunkParse
    , main
    , parse
    , puzzleInput
    , solution1
    , solution2
    )

import Html exposing (Html)
import List.Extra as List
import Parser exposing ((|.), (|=), Parser, Problem(..), Trailing(..), lazy, oneOf, succeed, symbol)
import Parser.Extras


solution1 : String -> Int
solution1 input =
    input
        |> parse
        |> List.map score
        |> solve1


solution2 : String -> Int
solution2 input =
    let
        sortedScore =
            input
                |> String.trim
                |> String.lines
                |> List.map autocomplete
                |> List.map autoCompleteScore
                |> List.sort
    in
    List.getAt (List.length sortedScore // 2) sortedScore
        |> Maybe.withDefault -32


type Chunk
    = Chunk


parse : String -> List ( Char, String )
parse string =
    string
        |> String.trim
        |> String.lines
        |> List.map chunkParse


score : ( Char, String ) -> Int
score ( c, _ ) =
    case c of
        ')' ->
            3

        ']' ->
            57

        '}' ->
            1197

        '>' ->
            25137

        _ ->
            0


chunkParse : String -> ( Char, String )
chunkParse string =
    let
        trimmed =
            String.trim string

        incomplete =
            ( '?', "" )
    in
    case Parser.run chunkParser trimmed of
        Ok Chunk ->
            ( '!', "" )

        Err error ->
            let
                len =
                    String.length trimmed
            in
            case List.head error of
                Just e ->
                    if e.col > len then
                        incomplete

                    else
                        case e.problem of
                            ExpectingSymbol expected ->
                                case String.toList trimmed |> List.getAt (e.col - 1) of
                                    Just illegal ->
                                        ( illegal, expected )

                                    Nothing ->
                                        incomplete

                            _ ->
                                Debug.todo "parse failed"

                Nothing ->
                    Debug.todo "parse failed"


chunkParser : Parser Chunk
chunkParser =
    oneOf
        [ succeed Chunk
            |. symbol "("
            |. lazy (\_ -> chunks)
            |. symbol ")"
        , succeed Chunk
            |. symbol "["
            |. lazy (\_ -> chunks)
            |. symbol "]"
        , succeed Chunk
            |. symbol "{"
            |. lazy (\_ -> chunks)
            |. symbol "}"
        , succeed Chunk
            |. symbol "<"
            |. lazy (\_ -> chunks)
            |. symbol ">"
        ]


chunks : Parser (List Chunk)
chunks =
    Parser.Extras.many chunkParser


solve1 : List Int -> Int
solve1 values =
    values
        |> List.foldl (+) 0


solve2 _ =
    4711


autocomplete : String -> String
autocomplete string =
    let
        ( illegal, expected ) =
            chunkParse (string ++ "|")
    in
    if illegal == '|' && expected /= "" then
        expected ++ autocomplete (string ++ expected)

    else
        ""


autoCompleteScore : String -> Int
autoCompleteScore string =
    -12


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
{[<({(<(<{((<(()())[()<>]>({[][]}{<>{}}))[[({}[]){()<>}]<{{}<>}(<><>)>]){[{{<>()}[{}<>]}({()[]}([]))]{{[(
<{<({([{{<[[{({})({}<>)}{<<><>><<>())}](<<[]()>(<>{})>[[()()]{{}{}}])]{{[[()<>](()[])]}[<(()
{(({<[[{({[<<({}<>)<{}[]>>>{(<()[]>[[][]])<<{}()>((){})>}]})}{{<{({({}<>){<>}}<({}())>)}<(({[]()}
[((([{({[{[<<((){})[[]()]><([]){()()}>><{[(){}]>{(<>{}){(){}}}>]}{<<{[<>()]}((<>[]){[]()})>([[<>{}]{(
<{[<[(<[[{{{({()()}[<>[]])<[<>{}][[]()]]}}([((()())(<>())){{()<>}[<>{}]}]{[[<>[]]{[]<>}]([{}()](()<>))})}((
<{(<(<[<<<{<([{}()]({}()))[({}())]>[((()())({}<>))(<[]()>[(){}])]}(({<(){}>}<[{}()][()()]>)
{{[(((<{[{(({{{}}[[][]]}[[{}{}]]))(((([]<>)[{}{}>)[({}{})<[][]>]))}{({({<>()}{()[]}){<<>()><<
{(<([{[(({(<({()[]})[{{}()}[()[]]]>[<{()<>}{()}>{[{}[]]}])[[<{{}{}}[{}]>[{[]<>}([]<>)]]{([[]][<>]){{()<
[<[([<{{(({(<{[]{}}([][]>>({[]<>}{(){}}))}))[{({[<<>{}>]([<>()]<<><>>)}[(([]<>){<>{}}){[()()]([][])}]
[[<([{{<[[<<<<[]<>>[[]<>]>[([]()}[{}[]]]>><(<[<>[]]{[]<>}><[()][<>{}]>)[[([]<>)<()[]>][[{}<>]({}{})
{<({<{{(((<{{[[][]]<<>[]>}}([{<>()}[[]{})])>(<<{[]()}[<>]>>)){{{{(<>{})([]{})}[<[][]><<><>>]}<<(<>{})<()()>>{
<[({([({{<[{{[()[]][()<>]}}<([[]]<()>)({()}<[]()>)>]><[{([()<>]{{}[]})<{[]{}}>}((<[]{}>[()()]){{{}<>}
([<{[<{[<{{<{[(){}]((){})>([{}()](<><>))>[{{(){}}}[(<>()){[]{}}]]}}>][{<(({[[][]]}{{[]<>}([][])
{[[{(<[(({{[<[()[]](<>[])>({{}<>}[[]()])](<{()()}{{}<>}>({{}[]}<[][]>))}})<<{{[<[]<>>{()<>}]}<(<[]()>{<>
(<[{[(<<[[{[({(){}}[[]<>])([<>()]({}[]))]}]]{[<{[<<><>>[[]()]][[[]{}][{}()]]}>{({<()<>>([]())}([<><>][()[]]
{{{[[[<{<[<[<{()<>}<()<>>>]{{({}<>)<()()>}}>(({{[]<>}}{{[]()}[{}()]}))]{{[([<>]{{}<>})<<<>
[[[{([<[[(((<<[]()>(()())>[{{}[]}])<{[(){}](()())}(<[]()><<><>>)>){{<<{}>({}())}{[[]<>]<[][]>}}<
[{{{{(<([<<[{[<>{}]}{<{}<>><<>()>}][<[<>()}{()[]}>(<[]<>>[<>{}])]>>[[[(<()()><{}<>>){<()<>>{[
<[[{[[{[(<<{{{{}}}({(){}}[[][]])}><([<[][]>{()()}]<[<>[]](<>[])>){(({}{})<[][]>)<[<>[]]>}>>)({{<[(<>[]){[]}]
[{<[<<([(<[[[(()<>){<>()}}]{({<><>}{[]()}){{{}<>}}}]{<<<<>{}>(<>{})>({(){}}((){}))>(<[<><>][<>]><([]<>){[]}>
{{({[<(<{<{{({<><>})<{{}[]}{[]{}}>}<({<>{}}[[]()])<(<>{})>>}>{[<(([]())[[]()])[{{}()}]>({({}[])[[]()]}{(
([<[[({(<<({{<{}[]>[<><>]}})[<[({}[]){{}{}}][{<>()}([])]>]>>{[[[<({}{})[<>()]>{<()>}](<{[]<>}(()<>)>
<[((({<(<{{[({[]{}}{[]{}})({{}<>})](([[][]}[[]()])({[]<>}{()<>}))}<{<[{}<>][{}()]>[(()[])([]())]}<[[<>{}]][(
{{[<{[(({{([<[()()]{<>()}><[<>[]][[]<>]>]{{({}())([]())}[[[]<>]{<><>}]})}}({((<{{}[]}[<>{}]>{(
({[[[<([(<{([[<>[]]][{(){}}({}{})])}<(<{<><>}(()<>)>{{{}<>}})(({()}[{}{}])[(()())[()()]])>><(<{{{}{}}({}<>
([[[<((<{({([{()[]}{()[]}](<()()>(())))<{[()[]][[]{}]}[{(){})([]())]>}(<({<>()}<[]()>)>{<<()<>>(()())>})
[({((([<((([[{<>{}}<[]<>>]<[[]<>][<>[]]>]<[(<>{})<{}<>>]<<<>[]>[<>()]>>))[[{[[{}[]]{()<>}]}]<[[(<>[]
{<([({<[(({<(([]()){<>()})<([]{})(<><>)>>[[[[][]]<[]{}>]{([]())[<>()]}]}(<{[<>]<<>()>}{<()[]>
{[[{[[<[[[{{{([][])[<>()]}}<(([]{})[[][]])[{[]{}}}>}(({<()<>>[(){}]}){[(<>())(<><>)][{()}[[]]]}
{<({({<{(([[({[]()}(()())){({}{}){<>{}}}]]([[{<>{}}[[]]]((<>[])[<><>])]<{({}[])<<><>>}{{<><>
{([[((<<[[(<[((){})]({<>{}}(<>{}))>)[({[{}[]]}){<([]<>){[][]}>}]][[[{<<>[]>[<>{}]}[{()()}<{}[]>]
([[<[[[({[<[[[{}[]]{<>()}]]{<{()<>}{{}[]}><[{}[]]{(){}}>}>]})]([({[([{()[]}])][{<(()<>)[[][
[<{<{[[[<{[{<({}[])>[{[]}{<>[]}]}<[{<>[]}<()[]>]>]<([{<>{}}[{}()]]{(<>{})[<>[]]})[<<<><>>[{}]><<()<>>>]>}>
<[{<{[{{<<{<[[(){}]([]())][{[][]}(<>{})]>([([][])<[]()>][<{}{}>([]<>)])}[[[(<>())<()[]>]]]><({(({}())[[]
([<<{{{<([<<{[()[]]<(){}>}[[()()](<>[])]>([<[][]><{}{}>])>[[{{[]<>}[<><>]}]<([<><>][()()]>(({}[])[[]<>])>]]{
[(({{[{{[<<[<((){})([]<>)>({{}()}([][]))]([[{}<>]{[]()}]<<[]())<(){}>>)><{<{()[]}({}())>{{()[]}({})}}<(<{}()>
<{(<<(<[(<<{[{(){}>({}())]{[<><>][[]()]}}[<[(){}]{<>{}}>]>[<[(()[])[<>[]]][{()[]}{<><>}]>[([[]]){<()<>><(
[{{[(<((({((({<><>}([]))(<[]><<><>>)))}{({[<{}{}>({}<>)]({()})}(<({})[<>[]]>((()[]){{}})))})){{((<[{(
<[([(<[([[([<{{}{}}[[]<>]>[[()[]]({}())]][{{{}{}><<>()>}])<[{[[]<>]<[][]>}<{[]()}((){})>]{[{{}<>}](<[]<>>{()[
<[{[({<([[{{{([][])<[]{}>}((<>{}))}({([])<[]()>})]([[<()[]>(()<>)][<()[]>]]{<<<>>[<>{}]>[<<><
[[[[[{{[[{[[<<()()>{[]{}}>{{[]{}}}}]}<(({[{}<>][()()]})(<{[]<>}((){})>[{<>()}]))>]{<{((([]()){{}<>}))(
([[[[[{[(<[[<<()[]>{()}>[[<>[]][()()]]]([{{}{}}[<><>]][[<>()]<{}{}]])]><<[[<[][]>[{}[]]]([<>[]]({}<>))][[[(
<[{<[(<<<[{({<[]()><[]{}>})<<{()<>}(<><>)><<<>())[<>{}]>>}<<{<[]<>><<><>>}[({}[])<[][]>]>{[[{}{}]({}<>)]<(
{[<[{{({<{[[((<><>){<><>})<<[]>{[]<>}>]{((()()))(<()[]><[]<>])}](<(<{}<>>[<>{}]){[[]{}][<>[]]}>{
<[[<<<[(<<<{{[[]<>][{}<>]}}[[{[][]}[<>{}]]<([]){()[]}>]>[{<[()[]]{{}[]}><<{}<>>[()()]>}(<<<>{}>>)]>{[{
{<{{{{{[<<[(<([]{}){()<>}>)]>[{{<{<>()}>{{{}{}}}}}]>]}<[[<{({{[][]}[[]{}]}<({}<>)<[]()>>)[<([]()){<><>}><
{<(<(<<[<[(<[{()()}<<><>>][(<>[]){()[]}]><{(<><>){[][]}}>)<(<<(){}><()<>)>{([]{})})[<[{}{}]{[][]}>{([]
([[<[[((([(<<<<>{}>[<>[]]>>[((<>))<({}()}<()>>])[{({()}[<><>])({<>{}}(<><>))}[{{()[]}}[(())]]]](({{{(){}}<[][
<<[({(({([[<[{<>{}}{<>[]}]<([]{})>>]<(<{()[]}{<>}>(<[][]>{[]{}}))<{[[]()](()())}{<[]<>>(()<>)}>>])}){(<{{<{[
((<(({[([{{({([]<>){[]{}}}<((){})([][])>)[({[]{}}[(){}]){<<>()>[{}{}]}])}{<([<{}[]>[[]()]])<{[{}(
(([[<[(([{{{{{<><>}(()())}{(<>[])(()<>)}}<{<()<>>(<>[])}{[[]<>]{[]{}}}>}({[[{}<>>[(){}]]}(<<
((<[{([{[{<(<{(){}}<()()>>[{<>{}}<{}[]>])<{<[]()><()<>>}[({}())]>}}][[<[[{<>}][((){})<<>>]]<[
(<({([([(<{<{({}[])[{}[]]}<{<>()}{<>()}>>}>{[(<(<>{})(<><>)>{<<><>>{()<>}})<[{[][]}<[]()>}>]
{({((<{<(<<{{<()[]>[()()]}<{()[]}{()<>}>}<([[]()](<>[])>[{<>()}]>>({{({}())[[]{}]}{<<>><[]<
{{<{({[{(<([{[[]<>][{}[]]}{<[]{}>(())}])>(<<<[{}<>]<<>[]>>>[<<<><>>{[]()}>]><{{[()]}}<<<{}<>>[()
[<[[<({((({({([]())<()()>}<{{}()}(<>{})>)[({{}{}}{{}{}}){[[]<>][[][]]}]}({([(){}][<>{}]){[<>[]][[
[[<<[[[{({<[({<>[]}{<>[]})]({((){})}({{}[]}))>}[[(({[]<>}<<>{}>)({()[]}<()<>>))]<<([[]<>])[[[]{}]({}{})]
[<[[{(<{<<{{(<()[]><(){}>)<[()[]]([][])>}}({<{{}}[[]()]>[{<>{}}]})>[[<{<[]()>{[]{}}}<<{}[]>[{}[]
(<<{<<({{{[[[([]()){[]<>}]](({[][]})<((){})[<>{}]>)][(<({}())>[({}{})<<><>>])]}(<{([<>()](()()))}{{[<>]{()
[{([<<[{{[({([()()]<[]<>>)<<()<>><[][]>>}{<[()[]]<[][]>>([()[]]{(){}}>})[(({[]()}[[][]])[({}{})[{}{}]])[({[]
<({(([[<({<<[<{}()>{[]()}]><<<<>[]>{{}[]}><(()())[[]{}]>>>})>{<{[({<[][]>(()<>)}[[{}{}]([]<>)])<{(())}{{[
({(<[[<([{{[<{{}<>}{<>{}}><([]{})>]<{[[]{}]}>}(<({{}[]}{()[]})((()<>)({}()))>({{<>{}}<<>{}>}([{}]<
[<[[[{({[{<{{[{}[]}[<>{}]}[[()<>]([]<>)]}>}[{[[{(){}}<()<>>][{()[]}]]<(([]{})<(){}>)([()<>][<>{}])>}<([[
<{{[{(<<(<[<({()[]}((){}))([()]<[]<>>)>([<{}()>({}())]([[]{}]<[]{}>))]({([()]<(){}>)[(<>{}){<>()}]}<([[]<>]<{
({{[([[{((<(<[()][()[]]><[{}<>]{{}()}>)<{<[]()>([][])}([<>()]<{}<>>)>>([[<[]()>([]<>)][{{}()}{<>[]}]][({()()
[({<({([[{[[<[(){}][[]{}]>]<[((){})(<>)]>]{{{{()()}[[]()]}{<{}>[<>{}]}}<[<<>[]><<>()>][<()[]>[<>{}]]>}}<[(
[{([<[((([{[({[]()}{()()})({<>()}<[][]>)]<<{[]{}}>>}([{({}<>)}[{[][]}<<>()>]])]{<[(((){}){{}{}})]({(()[
(<({{(({(<({(({}())[(){}])<({}[])[{}{}>>}((([]())<[][]>){(<><>){{}()}}))[{({()<>}{[][]})(<()<>>)}]>)}))
(([(({{(<{[[[{[]<>}<<>()>]<{<><>}([]())>]([([]<>)<()<>>])]}<[(<<<><>>}{{<>{}}[(){}]})[(<[]<>>{<>}){{[]()}
{{{[<<([(<(<[{{}()}[(){}]][{[]()}{<>[]}]>([[<>[]]{[][]}](<<><>>{[]{}})))<[[[()()]<<>{}>](<(
({([[[[(<[{([[{}{}](()())])}]<<<[{<><>}<[]{}>]<({}<>)>>[[{()}[()[]]]{([]<>){()<>}}]>>><<<[{[[
<{[(<{({<[({{{<>{}}<[]{}>}<((){})>}({[{}[]]<<>{}>}(<[]>{{}[]}))){<[(()<>)[[]{}]]>}][[<[{[]<>
[{[[[<<{<<[[{<<><>>(()<>)}<[(){}][[][]])]]>>}{<{((<[{}<>](<>{})>))}>(<[[[<<><>>{<>[]}][{()()}[[][]
<(<{{<<<{([({<{}()>({}{})}([{}[]]<{}[]>))<{[()<>]}[<()()>(()<>)]>]<(<{[]{}}{<>{}}><[[]<>](()[])>)<{<{}{}
[((([<<{<{[<{(()<>)<()()>}[[{}[]][{}]]>(<[[]()]>{<()<>>(<>())})]}<(<[<()[]>]>([[[][]}({})]<[<>{}]{[][]}>
<<[{[(<({<{<<{{}<>}[{}{}]>>([{[]()}{<>[]}]<<{}{}>{()()}>)}<<<<<>[]><[][]>>[{[]{}}(<><>)]>[(<[]{}>[[]()])(
[([<<{<<{<{{{(()()}{{}[]}}([()()](()[]))}{[([]{})[[][]]](([][]){()()})}}>}<[<[({(){}}{{}()})(
[<{(<({({{(({[<>{}]<[]{}>}({()<>}<[][]>))[(<(){}>)[{{}<>}[{}()]]])}<<<[{[]{}}[<>[]]][<<>><<><>>]><([{
{<<(<<{<{(({<{(){}}>((<><>)<()()>)})<[[[()<>]<{}<>>]]{({{}[]}<[]<>>)[{()()}({}())]}>)<<<[({}[])<<>[]>]{<
({[[({{{([<{({[]{}}<[][]>)<{[]{}}{{}()}>}{{{{}<>}}<<<>()>[[]()]>}><[<([]{})[<>{}]>]<<{<><>}<()<>>>[{[]}<
<({([[{[(([[(([][]){[]()}){(<>())}][([[][]])(<()>}]](([<()()><{}[]>]{<[][]><<>[]>})<{<[]()>{[]{}}}(<()<>
[{({(<<({[[(([{}<>]{()[]})[[[]<>]{(){}}])][<[{{}()}(()[])]{{(){}}[()()]}>{[[[]()]<[]<>>](<<>{}>{
{[<([[[{[([{([{}()]<()()>)}<<[[]]([]())><<<>[]>>>][{[{()[]}]({{}{}}{[]<>}]}])]{<({{{[][]}{<><>}}<<<>[]
(<{((({<[<<({({}[])([]{})}<{{}()}<<><>>>)<{(()[])(<>{})}>>{[[([]())(<>[])][<()>{<><>}]]}><[[([{}[]])(<[]()>((
{(([{[<[{<({[[<>[]][<><>]]<([][])[(){}]>}{{{[][]}<()[]>}}}<(([[]<>])[(<><>)<<>[]>])>>{[<[({})[[]<>]]{[{}[]
[(([(<([((([[{[][]}((){})]{[[]{}]{<>()}}]({[[][]](()<>)}{[{}<>]})]){[([[[]{}](<>[])]{((){})<{}<>>}
{{{({<[(<(<([(()[]){<>{}}])<({{}<>})>>[(<(<>{})<{}[]>>{([]<>)[[]{}]})<[(()<>)]({[]()})>])[[[({()[]}){({}<>
[[([[[(<<(<<(<<><>>({}()))<<[]{}>[()<>]>><{[{}[]]}[(<>)([][])]>>)([<{<()>(<>{})}>[(<()[]>[<>[]])(
<<(<[[({{<<({<<><>><[][]>}<<<>{}>(<>[])>)[{{[][]}{[]{}}}(<<>()>[()()])]>{(<[{}<>][{}()]](<(
({<{([[{[{[<{<[]{}>[{}()]}[<[]<>><<>[]>]>[<{[]()}[[]{}]>[({}[])<()()>]]]<(({{}<>}[{}()))[(<>{})(<><>)])<{
{({[<<([<<[[[{()()}{<>[]}]({<><>}<(){}>)]]>[{{<[<>{}](<>[])>}(((<>()){()[]})[<()<>>[{}{}]])}<(<
<[{[{<(<({{((<[][]><<>{}>)([<><>]<<>[]>})<[{[]()}{{}{}}](<[]()>[(){}])>}{{[<<>()>{[][]}]{{()[]}
(<[((<{([({{<{()}{{}{}}><{[]()}[<><>]>}[<[(){}]{{}()}>[<{}[]>[{}[]]]]})])((([([{<>{}}<[]{}>]<(<>[]}>)
[[((<({(({(<<[<>][(){}]>[{<>{}}[<><>]]>([{<>()}(<>())][[{}[]]])){[{[{}{}]{<>()}}[(<>())]]}}[<{[({}())<
((<[[<({<<{[<{{}[]}<()<>>>[(<>{}){{}[]}]](((<>)({})))}{<[[{}<>][{}{}]]{(()())([][]))>{[[{}{}]]{{{}[]}[[]()]}
{{[(<({{{[[<<{()<>}({}())>({{}<>}<{}{}>)>([[[][]]{{}()}]{[<><>]})}(((([]<>)({}()))(<[][]>))<(<<>[]>({}{})
[[{<[(<[[([[[{()()}{<><>}]<<{}[]][<>[]]>]{{[<>{}]}[[{}[]]]}](<<<[]()>[[]{}]><{{}()}<{}()>>>[[{(
[<{{<<<<{({<{<()<>>((){})}({{}<>}(()[]])>}{[({[]()}[()()])]})[{{<{()()}<{}[]>>}<[[(){}]{<><>}]{[[]<>]{{}<>
    """
