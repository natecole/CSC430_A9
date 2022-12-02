USING: math strings arrays kernel io prettyprint sequences
quotations combinators accessors ;

IN: interpreter


TUPLE: symbol 
    { id string } ;
C: <symbol> symbol

! ExprC
TUPLE: numC 
    { num real } ;
C: <numC> numC

TUPLE: idC 
    { sym symbol } ;
C: <idC> idC 

TUPLE: strC
    { str string } ;
C: <strC> strC

TUPLE: appC
    { fun }
    { args array } ;
C: <appC> appC

TUPLE: ifC 
    { if }
    { then }
    { else } ;
C: <ifC> ifC

TUPLE: lamC
    { id array }
    { body } ;
C: <lamC> lamC

UNION: ExprC numC idC strC appC ifC lamC ;

! Value
TUPLE: primVal 
    { args array } ;
C: <primVal> primVal

TUPLE: closV
    { args array }
    { body }
    { env } ;
C: <closV> closV

TUPLE: primOp
    { type symbol } ;
C: <primOp> primOp

UNION: Value primVal closV primOp boolean string real ;

! Env
TUPLE: binding 
    { id symbol }
    { val } ;
C: <binding> binding

TUPLE: Env
    { bindings array } ;
C: <Env> Env

CONSTANT: top-env {
    T{ binding f T{ symbol f "+" } T{ primOp f T{ symbol f "+" } } }
    T{ binding f T{ symbol f "-" } T{ primOp f T{ symbol f "-" } } }
    T{ binding f T{ symbol f "*" } T{ primOp f T{ symbol f "*" } } }
    T{ binding f T{ symbol f "/" } T{ primOp f T{ symbol f "/" } } }
    T{ binding f T{ symbol f "<=" } T{ primOp f T{ symbol f "<=" } } }
    T{ binding f T{ symbol f "equal?" } T{ primOp f T{ symbol f "equal?" } } }
    T{ binding f T{ symbol f "true" } t }
    T{ binding f T{ symbol f "false" } f }
    T{ binding f T{ symbol f "error" } T{ primOp f T{ symbol f "error" } } }
}

! : lookup ( sym env -- val )

: evaluate ( op args -- val )
    swap dup {
        { [ dup "+" = ] [ 2drop dup first swap second + ] }
        { [ dup "-" = ] [ drop drop dup first swap second - ] }
        { [ dup "*" = ] [ drop drop dup first swap second * ] }
        { [ dup "/" = ] [ drop drop dup first swap second / ] }
        { [ dup "<=" = ] [ drop drop dup first swap second <= ] }
        { [ dup "equal" = ] [ drop drop dup first swap second = ] }
        { [ dup "true" = ] [ drop drop drop t ] }
        { [ dup "false" = ] [ drop drop drop f ] }
        [ drop drop drop "error" ]
    } cond ;

: interp ( ast env -- val )
    swap dup {
        { [ dup numC? ] [ num>> ] }
        { [ dup idC? ] [ sym>> id>> {
            { [ dup "false" = ] [ drop f ] }
            { [ dup "true" = ] [ drop t ] }
            [ ] 
        } cond ] }
        { [ dup strC? ] [ str>> ] }
        { [ dup ifC? ] [ if>> swapd over interp {
            { [ dup f = ] [ drop f -rot swap else>> swap interp f swap ] }
            [ drop f -rot swap then>> swap interp f swap ]
        } cond ] }
        ! { [ dup lamC? ] [ dup id>> swap body>> swap T{ closV . . . } ] }
        ! { [ dup appC? ] [  ] }
        [ "not an ExprC" print ]
    } cond 2nip ;


T{ numC f 3 } interp .
T{ idC f T{ symbol f "x" } } interp .
T{ idC f T{ symbol f "true" } } interp .
T{ idC f T{ symbol f "false" } } interp .
T{ strC f "hello" } interp .
T{ ifC f T{ idC f T{ symbol f "false" } } T{ numC f 2345 } T{ numC f -1 } } interp .
T{ lamC f { T{ idC f T{ symbol f "x" } } } T{ strC f "body" } } interp .

