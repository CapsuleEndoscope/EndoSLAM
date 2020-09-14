# include "mex.h"
# include "matrix.h"
// CUMSUMALL.CPP 
// This is a C++ code written to allow MATLAB to perform cumsumming on 
// integer data types.  This file was written as a companion to the 
// COMBINATOR M-File.  Integer data types that are allowed:
//                     int8, int16, int32.
// Note that this file has very little practical value outside of the use
// with COMBINATOR, because of the ease with which these data-types could
// overflow in a random context.  
// When using this file with COMBINATOR, N should be less than the maximum
// variable size allowed by the specific type.  For instance, when using 
// int8, N should be less than 127.
//                               combinator(int8(30),3,'p','r');
void cs_int8(const mxArray *inp,const mxArray *oup,int row, int col)
{
    char *INP, *OUP;
    int hh;
    INP = (char *)mxGetData(inp);
    OUP = (char *)mxGetData(oup);
    // Copy the first row.
    for (int jj = 0; jj < col; jj++)
        *(OUP + row*jj ) =  *(INP + row*jj );
    // Perform cumsumming.
    for (int ii = 1; ii<row; ii++)
    {
        for (int jj = 0; jj < col; jj++)
        {
            hh = row*jj + ii; // Does this really save time?
            *(OUP + hh) = *(OUP + hh-1) + *(INP + hh);
        }
    } 
}

void cs_int16(const mxArray *inp,const mxArray *oup,int row, int col)
{
    short *INP, *OUP;
    int hh;
    INP = (short *)mxGetData(inp);
    OUP = (short *)mxGetData(oup);
    // Copy the first row.    
    for (int jj = 0; jj < col; jj++)
        *(OUP + row*jj ) =  *(INP + row*jj );
    // Perform cumsumming.
    for (int ii = 1; ii<row; ii++)
    {
        for (int jj = 0; jj < col; jj++)
        {
            hh = row*jj + ii; // Does this really save time?
            *(OUP + hh) = *(OUP + hh-1) + *(INP + hh);
        }
    } 
}

void cs_int32(const mxArray *inp,const mxArray *oup,int row, int col)
{
    int *INP, *OUP;
    int hh;
    INP = (int *)mxGetData(inp);
    OUP = (int *)mxGetData(oup);
    // Copy the first row.    
    for (int jj = 0; jj < col; jj++)
        *(OUP + row*jj ) =  *(INP + row*jj );
    // Perform cumsumming.
    for (int ii = 1; ii<row; ii++)
    {
        for (int jj = 0; jj < col; jj++)
        {
            hh = row*jj + ii; // Does this really save time?
            *(OUP + hh) = *(OUP + hh-1) + *(INP + hh);
        }
    }
}

// void cs_single(const mxArray *inp,const mxArray *oup,int row, int col)
// {
//     float *INP, *OUP;
//     int hh;
//     INP = (float *)mxGetData(inp);
//     OUP = (float *)mxGetData(oup);
//     // Copy the first row.
//     for (int jj = 0; jj < col; jj++)
//         *(OUP + row*jj ) =  *(INP + row*jj );
//     // Perform cumsumming.
//     for (int ii = 1; ii<row; ii++)
//     {
//         for (int jj = 0; jj < col; jj++)
//         {
//             hh = row*jj + ii; // Does this really save time?
//             *(OUP + hh) = *(OUP + hh-1) + *(INP + hh);
//         }
//     }
// }

// void cs_double(const mxArray *inp,const mxArray *oup,int row, int col)
// {
//     double *INP, *OUP;
//     int hh;
//     INP = (double *)mxGetData(inp);
//     OUP = (double *)mxGetData(oup);
//     // Copy the first row.
//     for (int jj = 0; jj < col; jj++)
//         *(OUP + row*jj ) =  *(INP + row*jj );
//     // Perform cumsumming.
//     for (int ii = 1; ii<row; ii++)
//     {
//         for (int jj = 0; jj < col; jj++)
//         {
//             hh = row*jj + ii; // Does this really save time?
//             *(OUP + hh) = *(OUP + hh-1) + *(INP + hh);
//         }
//     } 
// }

void mexFunction( int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    mxClassID   category;
    const int *dm;  // Rows and Columns.
    int nd; // Number of dimensions.
    
    category = mxGetClassID(prhs[0]);
    nd = mxGetNumberOfDimensions(prhs[0]);
    dm = mxGetDimensions(prhs[0]);
    //  set the output pointer to the output matrix
    plhs[0] = mxCreateNumericArray(nd,dm,mxGetClassID(prhs[0]),mxREAL);
    //  Call the other functions to do the cumsumming.
    // Several classes could be supported, but only three are used.
    switch (category)
    {
        case mxINT8_CLASS:   cs_int8(prhs[0],plhs[0],dm[0],dm[1]);   break;
//         case mxUINT8_CLASS:  cs_int8(prhs[0],plhs[0],dm[0],dm[1]);   break;
        case mxINT16_CLASS:  cs_int16(prhs[0],plhs[0],dm[0],dm[1]);  break;
//         case mxUINT16_CLASS: cs_int16(prhs[0],plhs[0],dm[0],dm[1]);  break;
        case mxINT32_CLASS:  cs_int32(prhs[0],plhs[0],dm[0],dm[1]);  break;
//         case mxUINT32_CLASS: cs_int32(prhs[0],plhs[0],dm[0],dm[1]);  break;
//         case mxSINGLE_CLASS: cs_single(prhs[0],plhs[0],dm[0],dm[1]);  break;
//         case mxDOUBLE_CLASS: cs_double(prhs[0],plhs[0],dm[0],dm[1]); break;
        default: break;
    }
}

// char -> int8, int -> int32, short -> int16, float -> single