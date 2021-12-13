module Day10 exposing (..)

import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, Trailing(..), chompIf, getChompedString, oneOf, succeed)


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


type Symbol
    = Open String
    | Close String


parse : String -> List (List Symbol)
parse string =
    string
        |> String.trim
        |> String.lines
        |> List.map parseLine


parseLine : String -> List Symbol
parseLine string =
    let
        parseResult =
            Parser.run
                (succeed identity
                    |= Parser.sequence
                        { item = parseSymbol
                        , start = ""
                        , end = ""
                        , spaces = Parser.succeed ()
                        , separator = ""
                        , trailing = Optional
                        }
                )
                string
    in
    case parseResult of
        Ok result ->
            result

        Err error ->
            Debug.todo "parse failed" <| Debug.log "Error" error


parseSymbol : Parser Symbol
parseSymbol =
    oneOf
        [ succeed Open
            |= parseChar [ '(', '[', '{', '<' ]
        , succeed Close
            |= parseChar [ ')', ']', '}', '>' ]
        ]


parseChar : List Char -> Parser String
parseChar symbols =
    getChompedString <|
        succeed ()
            |. chompIf (\c -> List.member c symbols)


solve1 : List (List Symbol) -> Int
solve1 _ =
    44


solve2 : List (List Symbol) -> Int
solve2 _ =
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
