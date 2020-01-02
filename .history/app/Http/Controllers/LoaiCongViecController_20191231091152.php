<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use PDO;
class LoaiCongViecController extends Controller
{
    public function CallFunction($ID_LOAI_CV, $TEN_LOAI_CV, $TRANG_THAI, $P_MO_TA, $P_ACTION, $P_PARENT)
    {
        $sql = "DECLARE
            P_ID_LOAI_CV NUMBER(10);
            P_TEN_LOAI_CV VARCHAR2(50);
            P_TRANG_THAI NUMBER(1);
            P_ACTION NUMBER(1);
            P_PARENT NUMBER;
        BEGIN
            :result := THEM_CAPNHAT_LOAI_CV(:P_ID_LOAI_CV,:P_TEN_LOAI_CV,:P_TRANG_THAI, :P_MO_TA, :P_ACTION, :P_PARENT);
        END;";
    
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_LOAI_CV',$ID_LOAI_CV, PDO::PARAM_INT);
        $stmt->bindParam(':P_TEN_LOAI_CV',$TEN_LOAI_CV);
        $stmt->bindParam(':P_TRANG_THAI',$TRANG_THAI);
        $stmt->bindParam(':P_MO_TA',$P_MO_TA);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':P_PARENT',$P_PARENT);
        $stmt->bindParam(':result',$result, PDO::PARAM_INT);
        // return response()->json($stmt, 200);
        $stmt->execute();
        return $result;
    }


    public function index(Request $request)
    {
        if($request->has('api_token'))
        {
            if($request->has('parent'))
            {
                $parent = $request->get('parent');
                $loai_cv = DB::SELECT("SELECT * FROM TB_LOAI_CV where parent=$parent");
                return response()->json($loai_cv, 200); 
            }
            $loai_cv = DB::SELECT("SELECT lcv.*, parent.ten_loai_cv FROM TB_LOAI_CV lcv
            LEFT JOIN TB_LOAI_CV parent ON parent.id_lcv = lcv.id_loai_cv
             ORDER BY id_loai_cv DESC");
            return response()->json($loai_cv, 200);
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
            // $validate = $this->validate($request,[
            //     'P_TEN_LOAI_CV' => 'required|max:50',
            //     'P_TRANG_THAI' => 'required|max:1',
            // ]);    
            if($request->has('P_TEN_LOAI_CV') && $request->has('P_TRANG_THAI'))
            {
                $ID_LOAI_CV = 0;
                $TEN_LOAI_CV = $request->get('P_TEN_LOAI_CV');
                $TRANG_THAI = $request->get("P_TRANG_THAI");
                $P_MO_TA = $request->get("P_MO_TA") != 'undefined' ? $request->get('P_MO_TA') : NULL;
                $P_PARENT = $request->get('P_PARENT');
                $P_ACTION = 1;
                $reuslt = $this->CallFunction($ID_LOAI_CV, $TEN_LOAI_CV, $TRANG_THAI, $P_MO_TA, $P_ACTION, $P_PARENT);
                return response()->json([
                    'success' => true,
                    'message' => 'Thêm loại công việc mới thành công',
                    'result' => $reuslt,
                    'status' => 200
                ], 200);
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
        $lcv = DB::select("SELECT * FROM TB_LOAI_CV where id_loai_cv = $id");
        return response()->json($lcv[0], 200);
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
        if($request->has("api_token"))
        {
            //CHECK TOKEN
            $ID_LOAI_CV = $id;
            $TEN_LOAI_CV = $request->get('P_TEN_LOAI_CV');
            $TRANG_THAI = $request->get("P_TRANG_THAI");
            $P_MO_TA = $request->get("P_MO_TA") != 'undefined' ? $request->get('P_MO_TA') : NULL;
            $P_ACTION = 2;
            $P_PARENT = $request->get('P_PARENT');
            $reuslt = $this->CallFunction($ID_LOAI_CV, $TEN_LOAI_CV, $TRANG_THAI, $P_MO_TA, $P_ACTION, $P_PARENT);
            return response()->json([
                'success' => true,
                'message' => 'Cập nhật '.$TEN_LOAI_CV. ' thành công',
                'result' => $reuslt,
                'status' => 200
            ], 200);
        }
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
