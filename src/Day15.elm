module Day15 exposing (Cave, NodeState(..), Point, State, Unvisited, increaseBy5, loopUntilGoal, lowestUnvisited, main, nextState, parse, puzzleInput, solution1, solution2, solve1)

import Array exposing (Array)
import Html exposing (Html)
import Matrix exposing (Matrix)


solution1 : String -> Int
solution1 input =
    input
        |> parse
        |> solve1


solution2 : String -> Int
solution2 input =
    input
        |> parse
        |> increaseBy5
        |> solve1


type NodeState
    = Initial Int
    | UnvisitedState { risk : Int, value : Int }
    | Visited Int


type alias Cave =
    Matrix NodeState


parse : String -> Cave
parse string =
    string
        |> String.trim
        |> String.lines
        |> List.map parseLine
        |> Array.fromList


charToInt : Char -> Maybe Int
charToInt char =
    if Char.isDigit char then
        Char.toCode char - 0x30 |> Just

    else
        Nothing


parseLine : String -> Array.Array NodeState
parseLine string =
    string
        |> String.toList
        |> List.map (\c -> charToInt c |> Maybe.withDefault -99)
        |> List.map Initial
        |> Array.fromList


solve1 : Cave -> Int
solve1 cave =
    let
        ( sizeRow, sizeCol ) =
            Matrix.size cave
    in
    loopUntilGoal (Point 0 0)
        (Point (sizeRow - 1) (sizeCol - 1))
        { cave = Matrix.set cave 0 0 (Visited 0)
        , unvisited = []
        , currentNode = { point = Point 0 0, value = 0 }
        }


type alias Point =
    { row : Int
    , col : Int
    }


type alias Unvisited =
    { point : Point
    , value : Int
    }


type alias State =
    { cave : Cave
    , currentNode : Unvisited
    , unvisited : List Unvisited
    }


loopUntilGoal : Point -> Point -> State -> Int
loopUntilGoal startPoint goalPoint state =
    let
        newMatrix =
            Matrix.set state.cave startPoint.row startPoint.col (Visited currentValue)

        newUnvisited unvisited =
            case unvisited of
                [] ->
                    []

                head :: tail ->
                    if head.point.row /= startPoint.row || head.point.col /= startPoint.col then
                        head :: newUnvisited tail

                    else
                        newUnvisited tail

        currentValue : Int
        currentValue =
            case Matrix.get state.cave startPoint.row startPoint.col of
                Just (UnvisitedState u) ->
                    u.value

                Just (Initial v) ->
                    v

                Just (Visited v) ->
                    v

                _ ->
                    -9999
    in
    if startPoint.row == goalPoint.row && startPoint.col == goalPoint.col then
        currentValue

    else
        let
            next : State
            next =
                nextState
                    { cave = newMatrix
                    , currentNode = { point = startPoint, value = currentValue }
                    , unvisited = newUnvisited state.unvisited
                    }

            nextPoint : Unvisited
            nextPoint =
                lowestUnvisited next.unvisited (Unvisited (Point 0 0) 99999)
        in
        loopUntilGoal nextPoint.point goalPoint next


nextState : State -> State
nextState state =
    let
        row =
            state.currentNode.point.row

        col =
            state.currentNode.point.col
    in
    state
        |> checkNode (Point (row + 1) col)
        |> checkNode (Point (row - 1) col)
        |> checkNode (Point row (col + 1))
        |> checkNode (Point row (col - 1))


checkNode : Point -> State -> State
checkNode p acc =
    case Matrix.get acc.cave p.row p.col of
        Just (Initial v) ->
            { cave =
                Matrix.set acc.cave
                    p.row
                    p.col
                    (UnvisitedState { risk = v, value = v + acc.currentNode.value })
            , unvisited = { point = p, value = v + acc.currentNode.value } :: acc.unvisited
            , currentNode = acc.currentNode
            }

        Just (UnvisitedState u) ->
            let
                newValue =
                    Basics.min (u.risk + acc.currentNode.value) u.value
            in
            { cave =
                Matrix.set acc.cave
                    p.row
                    p.col
                    (UnvisitedState { u | value = newValue })
            , unvisited = { point = p, value = newValue } :: acc.unvisited
            , currentNode = acc.currentNode
            }

        _ ->
            acc


lowestUnvisited : List Unvisited -> Unvisited -> Unvisited
lowestUnvisited unvisited acc =
    case unvisited of
        [] ->
            acc

        head :: tail ->
            if head.value < acc.value then
                lowestUnvisited tail head

            else
                lowestUnvisited tail acc


increaseBy5 : Cave -> Cave
increaseBy5 cave =
    let
        ( sizeX, sizeY ) =
            Matrix.size cave

        current x y =
            Matrix.get cave (Basics.modBy sizeX x) (Basics.modBy sizeY y)
                |> Maybe.withDefault (Initial -999)

        add v x y =
            Basics.modBy 9 (v + x // sizeX + y // sizeY)

        newValue v =
            if v == 0 then
                9

            else
                v

        init x y =
            case current x y of
                Initial v ->
                    Initial (newValue (add v x y))

                _ ->
                    Initial -9999
    in
    Matrix.initialize (sizeX * 5) (sizeY * 5) init


main : Html Never
main =
    Html.div []
        [ Html.p []
            [ Html.text (String.fromInt (solution1 puzzleInput))
            ]
        ]


puzzleInput : String
puzzleInput =
    """
9899623167955799382567812944379969888862225189992795696599917679656768699999959517619965244969693964
9299799754769995528964879691987994394279962991817261288292875969792662487997119818181869584684876846
7797846998192515817979298977311989795237984959677986552466183891499117966741289581161899999893535995
2746871998587973835699889998392494767471869998599394899949381694296896989189962932964957933899542279
9758993391987992656989818498486988599883838318197866615597799585988981991747229849497999993243298395
9399859277754624991914794999879918389948983892536995414838519589749997992375963822994963898129816891
4988761796994698798992294593199869969449299299888928699598878616594466846698991331991384879288286649
6681812758921325927688654155918195422521578475935721834774323989692982969497917655999285958895411188
9294959984991949829739979782757486496875798879567285829265899568198989661156887948394893429849894344
1989218789489289118884889794782687999839837887113234849779927951925453711933428829589699775283299939
7113936997884496159763714189899331495417669273479968229199411999655789958743868829834719469784979991
9937892998524945938896699224293782778973971162817489767755178489985773997289738882981958789689969738
9893667719871253431939794519776593881899999984999962999886168599984689197789256958928814719171836987
7696995999998819843579887897889999959818767599838619996753857949223958869799888996941198418198283783
1289497758397697991165997178769891934583779487914994292296484372375549278795469999576912852999577146
2145499618574685969944916191819694176889517862891987992286738596322515719885117867136329394989169918
7838949788839218366923347957991884889313781679758899928466899961477194699875195737897469919119172964
8969814999876973195999999664518987675889217897686288588198473581989799964747919586577197883617842912
3646447111298979939618644396846388979979632986751561976254775749577761761684199897989861979978818249
3693987887785199696529192391881158366749834784416121923891965298714355149487439797789695651691994849
4399691971845787891217793292838938799899841989958969696922899969166555789939469791978193767969589599
1597452938979863187994895272216937677557565817137799589361998819892494688832787778742593847599654928
4998869993788952899573655981676899457612878235987545139618869168599744167461768978559866999931887219
9918547918588952892628699998876576788789978665681743292193488577137979718219286915399767218557788869
9998367769929846173918588599919843778167888739193129964797338846491478969759283689171367669868696599
9829571337865973928146726168773595121993396595989823959918677438974595858859326775998195658642797956
5793777994687577296639276199298961337939999276974564922373996999998896861236943745399984915955692759
8789948788688489312693916698488579198763994399199437915419489358888884961886351789858973958786889999
5879997993698997672824288898985156878882726578969987158868171318286218527399415884599865885525859388
8379442598616924549819587897983867986988889799152599316616759976993492798923293246979593289985791628
3968859989982898979586988795551294599557648419698923978899722987994894199989792982774967868858646279
9829239289228887898997945462929342499998978292194388196249998889225899862864989191819638899998777615
9967999499299697596478854784557388578189997996598585389567638994254119539615798295959637616748119532
7847779999158579987835924358969787977597752337899972679968795498957999379878979811614915695186989695
8787986185978797993569967519247299584691389899837387899257389889997699847936381982679869948118949973
8892258536995523797193975239126969921916799491982514589138849539992988167819349194725937978282692648
1878811997841889827197299198979379979548789491823826898798938518762468896781974994769838768796981188
6687799987379984289919668178999996996259698999986889991848599999617587193985177478619758877988414119
9796589979989554195357786964468849181957799166899932768913891979449599511641935582792967896999669568
9997594681917699997971899851259914198996778488197217597149189838338395538993679994299957334548182789
9796766148448919429994826289895989965276959822999699996172999933998459348899957977144691995889895635
9933948715818236524533482296321646865771299998466692471768748749714113978548698174997268924649799377
1115792324352764449879949619583961556985945166299981779898828999849818899727394899987459918996791614
9999526461777598464699652921794786889797998584659354994685156891439971996969999759889814757629997878
6911834446491822919437989977369664983425959695491256751688945588669787213118199192181885639885788986
7193244156988889749827796999989172687638671791497992997829991156878759879964242959949842255399978886
8298127588799726879818241977767996679143687999194453896536629967662999355465118498999587781693887799
6159947745481178284839686663914258897928952293468359997988879622844586789396881149175166787919571489
7991294191117923999487293655288588353955581996927271977626982898577919799999782836662238781847999946
9999599756999399989749995889585696786827989887519995188912372378767849516399824963999418698929977812
5486736694189936967838185919999718893983154998987189478918393217519949289989328318899858999328984293
8949995919564717698297691783566233929798588899688918378766963916729833899587746499989898586989499812
3524193826987847299996184999799677595943978496911914269385247587789997827759828889367399941458756212
9696539817993691789966498932397742679824297799995798526139889399952988489928897934487195818678859583
2599943991191886966399997328964855991777927342867919884377589116899789189839698983799277993881888486
2817973579994999182718675472898896996529319459887399672919562861299341996661878975837749458982915958
3656841349489982595888934776772918197948998751789698339968959593759899927872797969479296179583462987
9157743798478765988169591329911428979929841499826518846685978789116659589136914999191949998749889195
5891119177956587927342315968196825692999686655731452887488589969889877497991875774999261196439919378
8971296237126599216899243157987983864699752899669959868888389188533951967961279963997198991967893968
9331713863971946599958118713939498189384492897577739798867798995264539518793295279888619399895643957
7299934981419753716499426161576357197977647997936887657763137838872996757748991898428989999246799711
2927598992939912676749895911999919121999689897797689859793677699896948178757849758699468979256775936
4996298679798776526899726187198594777667938181452251897585766569856979161831949999359379795567464978
6749697994899278119299119998411491197271389997591477879181293778862959568794255919916431991587389199
7917599295856995448398478815799177895955994437998988469939759999482637996873958891797158899568959974
3971493629788179694678156991899297599876983796147322799885496923998788465997492876993998775555847491
7589697756587167589199199931779484295478977888887947996911879683944986888123519869913756279999718376
9681891297599815159559839675522495189461498893954599819393873379999979518672477477171896578897588233
7218994464751199958895319996657748594987395382849437679243645291991819981869236327979599689979494557
3669579587841491999981887963937888932999949969968697361799957867798969849977367993858899197339573594
9938999157929999391948399198949897746612998265971677274753997966219884369519491683899788999296718841
2792979659919192951318997999298763787689864349785448519148893482199639421688567998269185598719848999
2956993919948418575296753192419975619989681488774889855393285898997153735745938167798389785972737993
8277731747919861157877398119967988787181989184148964479699868665199169958899862971952346887939119495
7957189873684459991539999918145326838946811314819664298566584999664824932481229968691232955488996359
5689899439928318983291862946713578981598998372769991897899964571991679961789499851669889897998923876
3992921155599616339882973837995998618999992927962947899864889685918698869875995491967919874765214249
5928994589588896418678769788982982467546658264292739286852797455119997956825919952139759634939363929
6466919491711156749275961775919918642899696899138799477759812969836989931761564516794132259978999975
6818715183889871995339229997318691989488799797672239864373984231579812138977183167796579991289844199
8299834651294894848996986998229879799792129998996896572993779468116894286897914723111995996593932918
9898961999279872995195669299467897939166178995288998948411783889832837489765636216821255797239972994
9294128842689878939853174458439783985991881697485769291768896997918381963397479848198981137733977259
9938693875599496191998786643916999989789656293298174199414987899951694925461891182769753418339819588
9299771958199974769247739386371956958922337417899967982645986299869439179889938853297748885816258959
5789218997367742787939849896229539979929943216698841986289892459919159297757929647191726176799837458
9997998899972949122469892269164697788597419659972681773616787817194787989924999971988949166393587685
8697819586862976298894966154799259953999979498492485569382199995858671376959237316117353968898987789
5833788449272889999938592989788917857997366887287599569391116987816957492646638194951369148466995865
8797392875679992576397998611946721199191997929616189898185668118656285951889998279779591569993782497
1243998587194789478969895899976929999998981784112911287566869897178888467393969798949922993999722783
6898491932163517498563145499993597998279478596617759269779837313979394939989887994797759687495749698
5918852999916934988579946896318848447798929874928938578765844728128792997498716499896334799391962229
1445281593898246791614118399847688799965474888492979999898593475998999989517878579949888291967993779
8819479319669561859977789779885299979994739846376789967696231939168985397398886199361944119969942269
8384597187994673998976978685877959945984938992895779118788869382587282961593144198939311957191999898
6891958879895544489956999491779892727268265764998397998885889467849955382531433982795569362982971997
4719927539178224292254897986253889381997819878927876771217358792678752779988195867984854987879869761
5496179226499867986599862998778132568199955188683452991319684698887391958959379992599899599281999798
    """
