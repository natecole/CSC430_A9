USING: A9 tools.test ;

{ 3 } [ T{ numC f 3 } top-env interp ] unit-test
{ "hello" } [ T{ strC f "hello" } top-env interp ] unit-test

{ "x" } [ T{ idC f T{ symbol f "x" } } top-env interp ] unit-test
{ t } [ T{ idC f T{ symbol f "true" } } top-env interp ] unit-test
{ f } [ T{ idC f T{ symbol f "false" } } top-env interp ] unit-test

{ 1 } [ T{ ifC f T{ idC f T{ symbol f "true" } } T{ numC f 1 } T{ numC f -1 } } top-env interp ] unit-test
{ -1 } [ T{ ifC f T{ idC f T{ symbol f "false" } } T{ numC f 1 } T{ numC f -1 } } top-env interp ] unit-test

{ 3 } [ "+" [ 1 2 ] evaluate ] unit-test
{ 6 } [ "-" [ 8 2 ] evaluate ] unit-test
{ 9 } [ "*" [ 3 3 ] evaluate ] unit-test
{ 12 } [ "/" [ 24 2 ] evaluate ] unit-test

{ f } [ "<=" [ 3 2 ] evaluate ] unit-test
{ t } [ "<=" [ 2 2 ] evaluate ] unit-test
{ t } [ "<=" [ 1 2 ] evaluate ] unit-test

{ t } [ "equal?" [ 2 2 ] evaluate ] unit-test
{ t } [ "equal?" [ "hi" "hi" ] evaluate ] unit-test
{ f } [ "equal?" [ 2 "hi" ] evaluate ] unit-test

{ t } [ "true" [ "arbitrary arguments" ] evaluate ] unit-test
{ f } [ "false" [  ] evaluate ] unit-test