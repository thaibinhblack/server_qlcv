<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
class FunctrionUserController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        if($request->has('ID_ND')){
            $id = $request->get('ID_ND');
            $functions = DB::select("SELECT * FROM TB_CN_ND where id_nd = $id");
            return response()->json($functions, 200);
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
        // $validate  = $this->validate($request,[
        //     'ID_ND' => 'required',
        //     'ID_CN' => 'required',
        //     'FUNCTIONS' => 'required'
        // ]);
        if($request->has('ID_ND') && $request->has('ID_CN') && $request->has('FUNCTIONS')  )
        {
            $p_id_nd = $request->get("ID_ND");
            $p_id_cn = $request->get("ID_CN");
            $FUNCTIONS = $request->get("FUNCTIONS");
            
            $view = $create = $edit = $delete = $export = $p_id_cn.'.0';
            $array = explode(',', $FUNCTIONS);
            foreach ($array as $value) {
                if($value == $p_id_cn.'.'.'1')
                {
                    $view = $value;
                }
                else if($value == $p_id_cn.'.'.'2')
                {
                    $create = $value;
                }
                else if($value == $p_id_cn.'.'.'3')
                {
                    $edit = $value;
                }
                else if($value == $p_id_cn.'.'.'4')
                {
                    $delete = $value;
                }
                else if($value == $p_id_cn.'.'.'5')
                {
                    $export = $value;
                }
               
            }
            $sql = "
            DECLARE 
                p_id_nd number(1);
                p_id_cn number(1);
                p_view varchar2(5);
                p_create varchar2(5);
                p_edit varchar2(5);
                p_delete varchar2(5);
                p_export varchar2(5);
            BEGIN
                :resulted := THEM_CN_ND(:p_id_nd, :p_id_cn, :p_view, :p_create, :p_edit, :p_delete, :p_export);
            END;";
            // return response()->json($sql, 200);
            // return response()->json([
            //     $view,$create,$edit,$delete,$export
            // ], 200);
            $pdo = DB::getPdo();
            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':p_id_nd',$p_id_nd);
            $stmt->bindParam(':p_id_cn',$p_id_cn);
            $stmt->bindParam(':p_view',$view);
            $stmt->bindParam(':p_create',$create);
            $stmt->bindParam(':p_edit',$edit);
            $stmt->bindParam(':p_delete',$delete);
            $stmt->bindParam(':p_export',$export);
            $stmt->bindParam(':resulted',$resulted);
            $stmt->execute();
            return response()->json($resulted, 200);
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
