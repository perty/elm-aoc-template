module Day3 exposing (solution1, solution2, view)

import Html


view : model -> Html.Html msg
view _ =
    Html.div []
        [ Html.text "Day 3, problem 1: "
        , Html.text (solution1 puzzleInput)
        , Html.text ". Problem 2: "
        , Html.text (solution2 puzzleInput)
        ]



-- Split input in two halves.
-- Find the character that is in both.
-- Lookup it's points.
-- Sum the points.


solution1 : String -> String
solution1 input =
    input
        |> String.trim
        |> String.lines
        |> List.map split
        |> List.filterMap commonChar
        |> List.map points
        |> List.sum
        |> Debug.toString


split : String -> ( String, String )
split string =
    ( String.dropLeft (String.length string // 2) string
    , String.dropRight (String.length string // 2) string
    )


commonChar : ( String, String ) -> Maybe String
commonChar ( left, right ) =
    left
        |> String.toList
        |> List.map String.fromChar
        |> List.filter (\c -> String.contains c right)
        |> List.head


points : String -> Int
points string =
    string
        |> String.toList
        |> List.head
        |> Maybe.map charPoints
        |> Maybe.withDefault -9999


charPoints : Char -> Int
charPoints char =
    let
        code =
            Char.toCode char
    in
    if code >= Char.toCode 'a' && code <= Char.toCode 'z' then
        code - Char.toCode 'a' + 1

    else if code >= Char.toCode 'A' && code <= Char.toCode 'Z' then
        code - Char.toCode 'A' + 27

    else
        -99999



-- Split into groups of three
-- Find badge for each group.
-- Sum value of each badge


solution2 : String -> String
solution2 input =
    input
        |> String.trim
        |> String.lines
        |> makeGroups
        |> List.filterMap findBadge
        |> List.map points
        |> List.sum
        |> Debug.toString


makeGroups : List String -> List ( String, String, String )
makeGroups strings =
    case strings of
        m1 :: m2 :: m3 :: [] ->
            [ ( m1, m2, m3 ) ]

        m1 :: m2 :: m3 :: rest ->
            ( m1, m2, m3 ) :: makeGroups rest

        _ ->
            Debug.todo (Debug.toString strings)


findBadge : ( String, String, String ) -> Maybe String
findBadge ( m1, m2, m3 ) =
    m1
        |> String.toList
        |> List.map String.fromChar
        |> List.filter (\c -> String.contains c m2 && String.contains c m3)
        |> List.head


puzzleInput : String
puzzleInput =
    """
PnJJfVPBcfVnnPnBFFcggttrtgCrjDtSjzSS
llWlLbmmdLLwLbqGdmTmbZfCQtzrMQfrjSzrtSrMqgMt
sHlZTsWZwGGlZmGTmdlZbhJNRPphVfRvVnRBsRsJJV
fsHtVbjtqstBghhwwPBw
SDQzzSzQrQMmmQlmlcNcJLZPgLrVZTdCddhgdPwwCw
JmSWSVGGlJJbRsbpWHfbRj
tJndRtwtddPvllvfrldrfPpHWDgglFDWWmMmHWmHpZlS
BBJTTjCsJWZCmSHSZD
LhqLcVzshTNjhqhcjLLTLjbTnGndfdwrfPRVRrdnwftQwJRv
wHlPJZwbbZfqbFwqFZfrrcrJrtMWSMMVtVcJht
NzzzNBjNfLzvGfDNjMhVhrrMShLchsRVLs
DDdmmgBGDNdgfgZggnZbZHln
jqNjZJqsGsRqJJqnlJJGzMzffcffTCfQcFmvcWfvTNfcvv
PdhVdrwphhVtDdSPLmFCWTLFWWTfFQQr
dSPwbbVdbpQllZMQbMjM
QQdfflqvjTvfZqLMWfNDGhwsCNGGGM
rzRRRTVTPTNhsDWDRhGC
gHSTpTnppvjQgJjcql
nzNvsFBBBFsNrnNBrvndfThwDbhVPzVVwhZZChpZPCbZ
GMQQStmcHHmlfMtPwbZVVVVhhPhbVc
GmSmMGlmWWgqQMHgQHtSvTNTTrgBBvNvFsfTfLvd
VNVBgRRBRzWRRbRTrTBgbzpZvMvMJlQJZJpJvlTMdJlp
mfdfdfdHfQplZJJh
ttnPmsLHmqsPGgWjjWRbBdbbGj
mMMzwFFpnwgMggSzhQSbSJbhWzbr
NPRlHHPbPRdPHCdRNGWWhWQhJVVGhZrCCJ
LlNbRllLLdHnpLgMTgTsDT
mWhvwmthrzJrLhvftwPrtNHlbcHgbDzNDHcGgzllHl
TCjdSCFMQCCCjMspCMQBMqpFHNGblPPnGNNbpnpccZGccclc
jVBPsqdFMFsTVMsdMmfwhwvVwLrvWhVtJR
TdhJJttgmdgctBBhBwBqBCLWqC
fjNGPblpPlRDfsfGbfcWqBqwWvnHVvBLVHss
lpRNDGjbrGfPZbmZZMFdTzTgcFdS
WPLMvWLMqLcSvrrBmDPFfRzmDPRfZDHP
dCggNCCdNCbHTHTfFnNHzM
GlJVQjdCCwjMGbGpjGdCpqrtctqcttchsrLLcthlhc
jgPHPgjGCwrqjqrvzBfFfCTTCdFpDD
QhQLtcrQQLWshQttdzzvzBnhvvBhvFTv
RJRssrQSWQSqjqqVSSGP
sPszmnmnQPQbjSRVVjbRjVVB
cdvZqMfNchMMMqCBlBZlmSmWCHBj
dFFDqJNNJvTJTqvvwmGQsGwJztgrwsts
dJGPMNStSclWJSPScMNMzqqDfzqVzwwjGfzjqfQz
hppFbrhFrrhgCpFlFhvFTgrsDfsjVzvLDfqwVzzwQDsVwL
RrgnZbphTpbgrnZgmpbhFcMlnWdMBNWJdtNJBMMSMc
HqtfLZCLmLtrSqZStzFtwpPQWlNQBpplpQWmBpNp
jMJcnRFcJjvjvcGvdJpBppBwQBpwQWPW
DcvDgbhjMMsjGvcjRRvjvgbGtsTZFHCCHSCHZHLfsSsCSrZH
wvFPFqvjlgTwjvjZbMSzHTSScMBBbN
VVmpVsmmptfDsdSZbMzZzMZBtB
LVhfGJVhQsWhVJhfmGJMwljFvqWrlPvCqrqjFFvj
cdNbtwrtwrRNLzhQhHfCzbGzQH
DMlMgFDBMSBjMTqMFWMFDQHdGZHvQdTHHvHzHChJJv
MBVWDngVqVWlqqBgBjjcsPnwnNdNsPNPpRcLws
pQqHsBmmrQHrrmsmmpwMdfdPbfWPMVbMdWbPwG
ZSvZDlvghgSDZCSzJZzgZNNPFRFMVRVfMdbFPddfMzGRWR
vWgJhSntvglSgDCHsjHBBpnTrTmjmB
hDgmmgnwDCdddRCqCPzz
sSslHbctbHsNrhpZqdqprc
WbsHSBQHQBLHTWJSlmjnVwFDvWhnvjmfgv
phwdhVLRddWJLVglLWRlWWgwhCjCrrrHZmCjZNHtjvvZrHTN
zzFzPQqFDcFsHsFPHSsGSCCNmftjjNDjCfCCCNfvrr
BSQsqFQMcPqHbcGzFMWgLlgwpLlpJLLpBwnp
GTrsHGGHfGMvsrGsvnGcHsvTwhghwhpVpJhQpwhQghhmmm
bFPFPPtSdPtSZPZWjSdZSNFdmhDJQgRQbQgmhJgJmRwVQMRh
jPdjldqlSNBdFBjtFZsfsGMqsHCMcqcfvnrf
crZHHZcZZsSrVrSCrBNTTpppBpJBCbwbBn
DzhRggfhhlRghmBNBpLJwDpDDTNp
qvwqwPRfvfzPPRvQlfPvPlRjZSHZrcScWrtVQscjjtZHMS
GRGBgsgghbvRvgsBTsgRjjznCCtSVCZtCFZtzFtwnSdj
cmqpPNnWWPrqWHplHDDcpCddFfZdFtdrwzrfdVFFdt
lPNPNPcqpcHWmPLllDDGhbRbnMgLgRbvRsbhhg
ZRBBNFWWBWPDZZprnwVvDD
bSzzhHdttMtCCzCThMTShStcvrqNNjwnrcvqvvVVpprvnnpN
CStdTMLztMmTSSMTSSSfBQNWlsFRJRPfmlNRNB
pMLptvGHTSGSHtLLwNWvcqsJmWWzmPFFms
nrQPrjrddgQlDPZjdlBcFFzFsFWhqWgshszhNW
CZDCQjjBBjrnCfQCrZrbSbHLRwGftbfPbHRMfp
sqQHBqsHbwDtmbSB
GjVGrlsMsPjbPbPmTtSwDb
lzFFGznLGGrLrnrVzMzsqvpqvWQcnNZWvCpnqpHc
nZWZjdWRwhRdBRhhdNZMtHtpPrGCCGsrTGsG
DzFFbblvbzFvVJzzzlVmvlpTpMpMrMCgGMtprJgCMrPM
zVmFzFvfzSmDzmCmzmmVQwNRqdRhcWBqShjqNndWWj
QQTdgLQlhGhQdPbwJJgwRVmtNRBV
vCSnjzFqSDDFMDjvrqvjvnVBRsNJRpJwtNJNpNrtbtbt
DfnCCjDMzcnqvHZGlcTcZThBlG
lWtmssWNcBjTjhlLpn
fwJbgfQfVfqPwmdgJjppHTjCphppBHCnhV
bgvfmvmbqdfDqJvqgbPJNDNSMscNDtccDzzcNtRt
ttBHSflTlqwGGQJBQq
jvdPdPLsDvCzvVqVQQGw
ZDdZnPrrPLPLZMZlfWSqmmTWmtTMtF
ShhwCZSwlPwZPSplwlRGGVmttWVVQcJVnJtSJVLcjc
qmzDmgNqNfgtJWWqtQLJqL
rsFgvrmFdfRhPBRvRRPZ
RQQRGJRpfJzlTQmbfbsGlsTMSHMPgcMFpgqPHHpHqqPpcP
WmLZDBBLZLNVdjWqDCFHCMccSPgSgg
thrNBVVBrWZNBWNrRGQbRtJGzlRRbmlf
NfdjBfsnDfNjfBddNBnBwsQShzQDhSDhvZSRDpFRSVFQ
lHrbTgtLmrblPzShhRpvRPZPVz
tWbqHlHmWHgWHtqrLJJsvBwnBfjswjwnNMwf
qQfdCVqZSqZmQmgVqCqCWTMcNFTwWwTccgpcWcpw
nSLrjrJnLcTwLNcz
sjRjSnJnRsBlPtnqCqCGfCbmQGHfCl
tqSmNPNcVrNNmPtHfMZbCWMCZbHwfdzW
RwgGvFwFdsssgjdb
LnLhhnFDStLJSrtw
HHGCHgfjgjgzNSTgJTDJ
WdMbDBdQLLZPWZVZZmLdzqqNbvzswSzrqqsJwSNw
QQmQBmWQZBmRPGfRjRcHccplpD
zFpjDvzDzWWvWBqDqvQcjsfbHPjHsVjcPGffGc
TttwldmlTPSCCZmhlNggwffhHsshRsGssRsfGHRhHf
twmMMmltZdNNlZLLMrPWzrrprpDr
ChCnpqhzCdndsDCnVpVJBgLTpTtgVggL
swHPGmwHbjPjvjQsGLSgVMtgSLLTVBHSrg
mRPPwvbvbvQjljvbPvPlfwWhsnhZDzFnWhDFdWcdhZWl
ndnSZSfNgmmSZlbllglVVsBCfqFBfttpPFtsqV
DJwcMzJDwLcMHMDRMRrtVWFWtCBqBWpWCzzP
wvcHhRcTJJvTRLRvRhwTQTHdQjqqGdgnbGQgSbqSbgNSdl
MHtvCFtCFvMvBDcVfjhhQf
WJZWSgZbdlwZZsbTbwDhcBVQhmTTTcfRjmjD
WwwrBwZsSJWwFttnLrMCpntn
BJgWJVSPVzNJNPZPVHBJHBfdhbjDnbQndnBnBQfndQ
MwMsNmNpmsrrwLssvsvpRpvQnCqbCCQfCfhhbDnqCfqLqn
MFvtrmGMFwRmFvcvMFmsWSVHWVHNzgZWTtWSTPSZ
wWNsHswfsWnVvNZvMLDRRpcLMBDnBlpR
QFdhqzFbzmgbhzQhFSLRrpBBBRcRBcLldpWc
SbmhzChGhqgQFFzqGJhwvtvNWCtVjVfwwZjHjT
WHGDHBRQHDBBQpGzBzQlDVjPmmVtbqbLmtPtzvmZbb
nchMhdMgCMJcwvLZvVcffjZfmq
ndhghggCwSnhCnnTNSdBpFWQFNLFlpHQpDLRGl
FZdjbqjjZTFbRHfVwgttfBZrBpBB
LJQFJWhPPnQJJQCPQpzwphczchrgtrfBrf
FFWvnlLGDGRMDHjm
jCsCNZTTfjcQMLWTtvHQvG
mgwdznllpRgBgpBDdnDDzBDmdrMHMLjtvvHJtLrWrHQWvQtv
lgjDpVSppmqsqssVPZPf
NcNwtChhScfPtwVRgmvWvWvNllVg
nZGJMJLnqqGzLzrGQvlmmgrTmWWlcVvR
LLdMzdssLZnMMbbZBJGsqLcjwjwPffpdtjFpFhPdFwjFFD
wQvZHfbLjrMZSVWMZSdZ
wwqhwtTRRpCCMmsnVlWGMpWM
qBDcqBTBtJCBDqctRDCBCzDFLfbfLwvfbQcFHNvLvvfQjQ
QDFwwvLJFjWQvWgGNnfNftCJPggP
lpqdpqqrqBBpTTBsprpsTsbrNGPfCPzftfPMMGztfzNgNflM
sqdpHrcbmTTHTdcspZNbZmDSQLQjhhSSWwvWWFHQvLLh
gjQHjfqgVSqjqMSnCRMDMvCGZDvCNCNJ
FnLswmdphJchhcZd
bslwFmLTTbWWmlmbBLwlpBHPPBjqHjBSgPSSSfrVnzqQ
JddrdBgJpChGfDLDDpcm
WnSFqRhnjjWSSlSFWqTFVSLGbDLcbLDDvDLztbftVzcv
nRWjsRjQFnQRshgwJCZwJrhw
rnbZwrcZQdpsLpHDVWBBBgDv
NNTSFCqJFMMMSJqTFFPttmNPlwgLvWvgWBffWlClLfvlVCVv
TMTTJSJFRNwmjZsnGsrhnZZR
CMZhZstZqlClJScfBrfHHHFWFFHh
RwGdpjdGVGdmNHcfczpJWWpf
dDJnQbdnwQdbggSPgPsnlqSn
hnczBfznJFmzhnzJLLMwLjmQrppgCjqC
HRRlrPRZSDtQjjPQNMPpPw
ttlZHDRGRlRtGltTtGvcbnFrbvWJhvWhndcFWF
hRsCqfRdqdqfqdtqmMmmZpStMTZZSTnp
VjDDjWbzPFFwPRPFDjzLSnTMnZSGZMnWpLLmpL
PVHFNBzDRbDwzjNNzHdvdHvlhhcHgvCglf
cRLLzhRBhLhVLLLMnnRVVhtJgNgPJmPgPvDPJgvzvvNJJP
lpFffHHWHbbMNPQgsgJJmW
lpdplSpHSHlCCTbSpSFwdnLqMwcdBRRRLdRnth
csZWwFFZbtbztcZttbnRbGlbJhqfnhlpnn
mmTjjBLdSMQdBggQHNgTmjgJJRqRhCJphRHRRClGnhlWJJ
MNMMNTmBLDmTLDSQmFDvvzwPWzsvDZFFcD
fmflRfGcCtGDDbRCRlhCmmBJQsvBBWWvtWBnBJvLLvLn
GFjdMMFGzVQvWWVWJQVJ
wjTZzjrFTHgZjTFjMwGRcfRcqlbhcccrcmmlqC
PvnvjHPnjRPPqvvnPqZNNWHTSdVDHwTLSDWDlTTTLl
MJswhgppwspJpJsGbhchbcMlLLDQdVSgVldtSlSlSTdTld
FwzwJzpfzzJRPZmPBvvmBF
ZrJhslhhclDJhrDZllcGGrZnFCCWNMCHfsFbPddwdwWwCCfP
BTjgvtBBSLqqBSLVzgTpBVMFHNPHwFbSwMPbMwbHMCPf
fRtTppTjRJmrmJDR
hJzcQcwMQhcQwZHVNmSmPCQZSm
tpfvgWFFGGfRWFBqtPrHCmSwPPVPwgVgPC
fpWBRqWqqGRpWWRpFWssMnLczJnnwcjscsJnLhbz
HggzqvvrgtlrrHlQtvlJqFdfBLFJBbnfbBBdfBBfFd
SVVmpZVsRLZGGZwRGZSTDWBbmBFBdFBnnFCnWnBfhB
wpjVppVpZLRTGZQrrjjHNzcgvjrg
GsMgMCFGMsbwbbSwwglS
mJDMqRJzTRVdPWttPffZppBBfS
dzcdqQcmQMGnHCsQ
HlPgHwlHVwsVPPFVsNwzwLnmRmCCMcJcMRRLqGtRjCjJ
dWhrWdDnmrrRMRct
BZDvBpfTDDfBddWTZhDddWDQgwsFsHVvVHgHHznFQFznlQ
FjmqFqJJGsBGGhsZdRDDRZZjTvdMdt
NnHPngrPbPpbPfVvfCrnwccTwrRwTZdcdTZLwRTD
lbbPvHWlHCNNnJzGJlQsJlsBBq
mLNRpRDcDDCmCpzTcCPcNTTDrrnrPrPvjqtqhnhhhqQQjrhF
dVMlVGgVSlGgWgsWSZlwtrHvqMjhnrhQjnBBqHqvhv
WJfsVwZfJGfdLNmcmCcCtztf
bBTtWQDMpDSjjznztCLd
JhfZfrNPPwNJrhqRcJjfCCCzLSGLbGGjGznj
RsPRZhwNbgbrgbBpBWWsQFvDMTDF
rqLzTmqqMmmwrqwrJJwPTplhbRDphhdhDvnnhnRDnP
ggfctFfSRNgZFBRVfFfWfZNSvjjvjCChpDhhDCCjdvlDDD
NQfFRFgtffcGfcgZcfBqJrGLJJqLTwwmmHJrqz
WVGJCltslWJsbbtNJbDJPMrPLBNLrpNjfqQQMMNr
nTFnTmdRnTmmmdHZZnPQpLMfMZPMPqLZDqLf
HRvRFRTvvvRmnvFcFRndcwVVJWWGbsJGwgttlCzJlGDg
rfwdfLwLwwNdwbLcgCCTtFPvFPzWtWVtzvJF
MpjqDDQQRmQjDspzTWWthVWRvRVRzn
ZTQQQqlQZsqlrlgwNlgLcSdf
QqBNgbNNJvcgnbBQQgJjQZSJWppPWsGpDpSGPpWTRDTp
rrldddlrChLFpWPSSPWvPGCR
fhFltdLhHwVfvgcZZqjzNNtQgt
BMCMQZSMvSZSQTQTWvMSvrrTccgGRNljBFglGRgBVgFGRRGc
ffmdmwdLbDJwFVNlGRRVVbRR
dwJnJLfJwLhnPQSSNMvMqhMP
RpQDDCHQwMRpwpNMCwpZhgZrPSqQdgrqPqPZqq
zbtzmzzGbVzJSTScZqrthddT
LVLJlLBnGnWNHMDRHnCCDh
wQDcLhScLLBStHhctwVwsBjNTrssTjgNsgGCgssj
fWblbRqMZWRffldFZpqWRbTCsPrsTNgnCQjgTrMGGgsr
FZRpqdlWWbZZJJJppWWdHQVmLLDmzwDcLSVcQJLw
DlllCDRlflQRsRnlCCBhzvLFVhJzJVzh
jHjNNqdHqwNgpgqNcpgZwjZhJJbvdbPVhBbbvVvBvLzbPF
cpcgSwWqgVnftSSTTf
QmLZvjwwmDWFLNLqbqfF
JJSBMBpdpgSBRBHJgdHBNVbsgqVlqfbVFVlqVFqb
pCttfdCRMDCjhPDhmQ
nDjnzdcDbDtGdcQTvssHssHbbfTq
lVgRgpWCrMRVgVglRLjJmQFHqHHHsqFvFfTQsHSfMQ
VrlpmWmgWppllLpPPWPWljPBntcnhdBNPhZBZhGdDd
fQsRRfBHvRRjjvSgTwCTphdlphqBpn
WJrDZbrNJZPWJcZmWLrrbPczpCnTddqdshqhDgTTwlwwTqhs
brcPbZPcWGWssGtVfVMjFF
GBZgqHhHGBZcLcGMjVJhrjrbStjbbb
wTTNFPQpvDQTQLQvntRSbRJjVnrSDtJV
TTwzQzPPTvmWLTTcdWfdGdZgfZHfZH
VswNdtMgdsvQDJgdVNgQrrLlhrSCLflqfLrDnzLL
RbjRbcZGTGpRbzrTqChtflhSnt
mBjPRWpGcmBZGZpmZjtRbQQVwJgsPsQMsvNJdsVFdN
TDmDTTThRDbbZtpTSnhRcFJMglldGdrJltgBMtMB
jNjsWLqqqvzWswNqdccrFNBFMBlMrdMr
LjjqwvsWCwjHwQHHTbDHbbRZmnRd
qtnncCFCqjwjcDwnFQSGGRSBGBSvFdvrhR
JPZzpgPJWNJBRhqSvQvBgB
mZmJmMPWzmWmPLbmqTTJPfDHnHjCjflHjflfDcfMwC
VfJrplTqzVVlVVlpfTMJfqDtWSLgbHgDjSHLgjHWjrjb
vhGsRdsNRPRvvRhjSZjJLPDjDJttbZ
GvGhQmhBnQNmnJGvhdFqBFVqcllqMBCMlVCc
cnmsmmDCBDmcmvVnsVBtQQWWrrltQlrBfRHB
hqphjLZFhMMjZQGQWGfftQWf
JhFqhbjSLjMpqzJFbSLdFSggDwgmgcDVsVzVfvNvDvsm
mRdspZZggmbJbpDcDJDqPhvvGvrnVqPqpzvVVV
dSjSjQtwfQlLwjQSPrrqVqvGPGPVPjnP
fMQtFQLHSfLtHFttHMflfwHWgFJsDbmJRDWdFBRJWmcbsJ
lMMftpGHMntGtMMGpJnSPQvwzvvHscsdQscQsscQss
hbfmWWLggVFjVVQdvbQvbcdzwbRR
qZWFWTgTZhrLhLmWGlGGrSnJSNfGtSll
QVGdmgVGLdllrGVgnZrdBvNvBSSjSvWtBHBqNNmv
ThRjRFwpfTNBBqSBSSvT
MFzbzfDjFFCCFJpRpFwbwJRnZndDgsZlgLrQLDgdlglZnD
PjbDQvQPjbjjvtrQcpHBWnLfqnqGcHngnLdf
VTwmMzMFnqHBwHBB
lMTTNCzCZmClVVQjstQpPlprlHSp
MtMqBtwFFsMRZMMZMjJGZR
PHbpbPqHmVVCRGGCGRjv
pdrrgdrqPbpzrHQbbqQPLHcQBsNtNnwzNhSFfhtfffFffwDs
cPjpPcRJJVtSGGtJtffN
CldrWrmDHnHnmWmTWsNzzfbbFNhtsbbNGGfb
LCDTldCmnLLVwPVgQt
NJpFrbpFZhlzhbzzqCtgMCgRbqCRMMtm
dWcnntHQWcjRHHCVMqCsRg
vLnQDvnGptrzLPwp
dwTwTHwvZHqTrTRTlWtfzt
GbFFbFBPnGQBQcQcLbPjFtCSrtgMMLrMfrrWgRgStr
PnBnQhsGPQbnJRqwdRDwvJNDwq
zzjWtnQRntzSBjZccmZmmC
bdJdbdfJdFCGflfGwBJsmhmSMgmgcsmM
qDbGDbvrFbbvGdvdffFdTTWQzrTWTLWLNnttLnCH
WMMssTqCbpGzGSlmzLbG
FVdwftRRVDZPcdZtZVRcjmvQSzzLrmlrclSGms
DVfPFZDZRfVFPFHRPFRCphhMpCTHTsNgqHNWgn
LzBGCRjHCnmnHzdzLLjHwGplflfrfPcgtflgLFLlcrcc
hqhDMSSqWZsDMVWTVWmTcglglflFVflFrpPtggcv
sshbJsTsqWMbqNWbhbzzjzGBQjCJQnzwmzBw
QnpfLpbLfGbvgjHzjgmNRqbz
SSMBMZDwMwFsqgSPPmHlHj
BhMFJhMBddDMFcTdMVddrQfvrnCqnCffpqnVCLtC
lhrTZNJZjCRjSCvRSlTSLlrvFnMHQhVDnqnmqqqmQqPDHmqF
wcpGdtwtwzcbpzggCFPMqtMQmQqmVqHP
bBfwgWbfwBdGpppGGGbcBsTRLlZTZsTRTsRNZClJsvZL
nJLgNcQDNMlQHMvCbv
zphFpmTszmwhGGFhhtppNfffVlvZvHCCVZzbfzvS
mTTsmTRGstsFhWwtWjPRdjnJdjJnLjcLNd
MfBDjllflHLTpDhhppDDbp
NZBBnGJNnNPWTcTTmVhZCh
PSzgSgwrnzrSzBGJSJrSLQqfMHQfqgRgfjHLljll
RgbNmBbqgWHWRNRqHtcMlMwJJjcDtVlD
SzpFLGPddSGnnSLQZLtJJcclDlVjDQwMhDcc
LtTZCTttRqqqvqTN
"""
