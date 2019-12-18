<?php

namespace App\Http\Controllers;
use DB;
use Illuminate\Http\Request;

class LoaiDuANController extends Controller
{
    public function CallFunction($P_ID_LOAI_DA, $P_TEN_LOAI_DA, $P_MO_TA, $P_GHI_CHU, $P_TRANG_THAI, $P_ACTION)
    {
        $sql = "DECLARE
            P_ID_LOAI_DA NUMBER(10);
            P_TEN_LOAI_DA VARCHAR2(50);
            P_MO_TA VARCHAR2(255);
            P_GHI_CHU VARCHAR2(255);
            P_TRANG_THAI NUMBER(1);
            P_ACTION NUMBER(1);
        BEGIN
            :n := THEM_CAPNHAT_LOAI_DU_AN(:P_ID_LOAI_DA,:P_TEN_LOAI_DA, :P_MO_TA, :P_GHI_CHU, :P_TRANG_THAI,:P_ACTION);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_LOAI_DA',$P_ID_LOAI_DA);
        $stmt->bindParam(':P_TEN_LOAI_DA',$P_TEN_LOAI_DA);
        $stmt->bindParam(':P_MO_TA',$P_MO_TA);
        $stmt->bindParam(':P_GHI_CHU',$P_GHI_CHU);
        $stmt->bindParam(':P_TRANG_THAI',$P_TRANG_THAI);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':n',$result);
        $stmt->execute();
        return $result;
    }

    public function index(Request $request)
    {
        if($request->has('api_token'))
        {
            //CHECK TOKEN

            $du_an = DB::SELECT("SELECT * FROM TB_LOAI_DU_AN");
            return response()->json($du_an, 200);
        }
    }


    public function store(Request $request)
    {
        // $validate  = $this->validate($request,[
        //     'P_TEN_LOAI_DA' => 'required|max:50',
        //     'P_TRANG_THAI' => 'required|max:1'
        // ]);
        if($request->has('P_TEN_LOAI_DA') && $request->has('P_TRANG_THAI') )
        {
            if($request->has('api_token'))
            {
                //CHECK TOKEN
                $P_ID_LOAI_DA = 0;
                $P_TEN_LOAI_DA = $request->get('P_TEN_LOAI_DA') ;
                $P_MO_TA = $request->get('P_MO_TA') != 'undefined' ? $request->get('P_MO_TA') : 'NULL' ;
                $P_GHI_CHU =  $request->get('P_GHI_CHU') != 'undefined'  ? $request->get('P_GHI_CHU') : 'NULL' ;
                $P_TRANG_THAI = $request->get('P_TRANG_THAI') ;
                $P_ACTION = 1;
                $result = $this->CallFunction($P_ID_LOAI_DA, $P_TEN_LOAI_DA, $P_MO_TA, $P_GHI_CHU, $P_TRANG_THAI, $P_ACTION);
                return response()->json([
                    'success' => true,
                    'message' => 'Thêm loại dự án',
                    'result' => $result,
                    'status' => 200
                ], 200);
            }
        }
    }


    public function update(Request $request, $id)
    {
        // $validate  = $this->validate($request,[
        //     'P_TEN_LOAI_DA' => 'required|max:50',
        //     'P_TRANG_THAI' => 'required|max:1'
        // ]);
        if($request->has('P_TEN_LOAI_DA') && $request->has('P_TRANG_THAI') )
        {
            if($request->has('api_token'))
            {
                //CHECK TOKEN
                $P_ID_LOAI_DA = $id;
                $P_TEN_LOAI_DA = $request->get('P_TEN_LOAI_DA') ;
                $P_MO_TA = $request->get('P_MO_TA') != 'undefined' ? $request->get('P_MO_TA') : 'NULL' ;
                $P_GHI_CHU =  $request->get('P_GHI_CHU') != 'undefined'  ? $request->get('P_GHI_CHU') : 'NULL' ;
                $P_TRANG_THAI = $request->get('P_TRANG_THAI') ;
                $P_ACTION = 2;
                $result = $this->CallFunction($P_ID_LOAI_DA, $P_TEN_LOAI_DA, $P_MO_TA, $P_GHI_CHU, $P_TRANG_THAI, $P_ACTION);
                return response()->json([
                    'success' => true,
                    'message' => 'Cập nhật dự án thành công',
                    'result' => $result,
                    'status' => 200
                ], 200);
            }
        }
    }

    public function thongke()
    {
        $thong_ke = DB::SELECT("SELECT count(lda.ten_loai_da) as sl, lda.ten_loai_da from TB_LOAI_DU_AN lda, TB_DU_AN da where lda.id_loai_da = da.id_loai_da group by (lda.ten_loai_da)");
        
    }

}
