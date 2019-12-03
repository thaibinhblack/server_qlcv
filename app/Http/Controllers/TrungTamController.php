<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use PDO;
use Yajra\Oci8\Query\Grammars\OracleGrammar as QueryGrammar;
use Yajra\Oci8\Query\OracleBuilder as QueryBuilder;
use Yajra\Oci8\Query\Processors\OracleProcessor as Processor;
use Yajra\Oci8\Schema\Grammars\OracleGrammar as SchemaGrammar;
use Yajra\Oci8\Schema\OracleBuilder as SchemaBuilder;
use Yajra\Oci8\Schema\Sequence;
use Yajra\Oci8\Schema\Trigger;
use Yajra\Pdo\Oci8\Statement;
class TrungTamController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        if($request->has('api_token'))
        {
            //check token
            // $sql = "BEGIN
            //     SELECT_TRUNG_TAM(:cursor);
            // END;
            // ";
            // $pdo = DB::getPdo();
            // $stmt = $pdo->prepare($sql);
            //     $stmt->bindParam(':cursor',$cursor, PDO::PARAM_STMT);
            $trung_tams =  DB::select("SELECT * FROM TB_TRUNG_TAM");
           
            return response()->json($trung_tams, 200);
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        if($request->has('api_token'))
        {
            //CHECK TOKEN


            $validate  = $this->validate($request,[
                'P_TEN_TT' => 'required|max:50',
                'P_TRANG_THAI' => 'required|max:1'
            ]);
            
            if($validate)
            {

                $P_TEN_TT = $request->get('P_TEN_TT');
                $P_TRANG_THAI = $request->get('P_TRANG_THAI');
                $P_MO_TA = $request->get('P_MO_TA') !=  'undefined' ? $request->get("P_MO_TA") : '';
                $P_GHI_CHU = $request->get('P_GHI_CHU') != 'undefined' ? $request->get("P_GHI_CHU") : '';
                $P_TRANG_THAI = $request->get("P_TRANG_THAI") ;
                $sql = "
                DECLARE 
                    P_TEN_TT VARCHAR2(50);
                    P_MO_TA VARCHAR2(255);
                    P_GHI_CHU VARCHAR2(255);
                    P_TRANG_THAI NUMBER(1);
                BEGIN
                    :resulted := THEM_TRUNG_TAM(:P_TEN_TT, :P_MO_TA, :P_GHI_CHU, :P_TRANG_THAI);
                END;";
                $pdo = DB::getPdo();
                $stmt = $pdo->prepare($sql);
                $stmt->bindParam(':P_TEN_TT',$P_TEN_TT);
                $stmt->bindParam(':P_MO_TA',$P_MO_TA);
                $stmt->bindParam(':P_GHI_CHU',$P_GHI_CHU);
                $stmt->bindParam(':P_TRANG_THAI',$P_TRANG_THAI);
                $stmt->bindParam(':resulted',$resulted);
                $stmt->execute();
                return response()->json($resulted, 200);

            }
           


        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
