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


: interp ( ast -- val )
    dup {
        { [ dup numC? ] [ num>> swap ] }
        { [ dup idC? ] [ sym>> id>> swap ] }
        { [ dup strC? ] [ str>> swap ] }
        { [ dup ifC? ] [ if>> interp swap ] }
        { [ dup lamC? ] [ body>> interp swap ] }
        [ "not an ExprC" print ]
    } cond
    drop ;

T{ numC f 3 } interp .
T{ idC f T{ symbol f "x" } } interp .
T{ strC f "hello" } interp .
T{ ifC f T{ idC f T{ symbol f "true" } } T{ numC f 1 } T{ numC f -1 } } interp .
T{ lamC f { T{ idC f T{ symbol f "x" } } } T{ strC f "body" } } interp .
