module divWrappper(outA, outB, expA, expB, signA, signB, infA, infB, zeroA, zeroB, nanA, nanB, normalA, normalB, op, result, exp, sign);

    input[INPUT_INTERFACE_INT_OUT-1:0] outA,outB;
    input[INPUT_INTERFACE_EXP_OUT-1:0] expA,expB;
    input[OP_BITS-1:0] op;
    input signA,signB,infA,infB,zeroA,zeroB,nanA,nanB,normalA,normalB;

    output[INPUT_INTERFACE_INT_OUT-1 : 0] result; 
    output[INPUT_INTERFACE_EXP_OUT-1 : 0] exp;
    output sign;




    assign exp = expA - expB;
    assign sign = signA ^ signB;
    
