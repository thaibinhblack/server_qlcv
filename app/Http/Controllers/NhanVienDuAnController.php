<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class NhanVienDuAnController extends Controller
{
    
    public function CallFunction($P_ID_DU_AN, $P_ID_ND, $P_XEM_CV_DA, $P_THEM_CV_DA, $P_SUA_CV_DA, $P_ACTION)
    {
        $sql = "DECLARE
            P_ID_DU_AN NUMBER;
            P_ID_ND NUMBER;
            P_XEM_CV_DA VARCHAR2(20);
            P_THEM_CV_DA VARCHAR2(20);
            P_SUA_CV_DA VARCHAR2(20);
            P_ACTION NUMBER(1);
        BEGIN
            :n := THEM_CAPNHAT_NHANVIEN_DA(:P_ID_DU_AN,:P_ID_ND, :P_XEM_CV_DA, :P_THEM_CV_DA, :P_SUA_CV_DA, :P_ACTION);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_DU_AN',$P_ID_DU_AN);
        $stmt->bindParam(':P_ID_ND',$P_ID_ND);
        $stmt->bindParam(':P_XEM_CV_DA',$P_XEM_CV_DA);
        $stmt->bindParam(':P_THEM_CV_DA',$P_THEM_CV_DA);
        $stmt->bindParam(':P_SUA_CV_DA',$P_SUA_CV_DA);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':n',$result);
        $stmt->execute();
        return $result;
    }


    public function index(Request $request)
    {
        //
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
            $validate = $this->validate($request, [
                'P_ID_DU_AN' => 'required',
                'P_ID_ND' => 'required|max:1',
            ]);
            if($validate)
            {
                $P_ID_DU_AN = $request->get('P_ID_DU_AN');
                $P_ID_ND = $request->get('P_ID_ND');
                $P_ID_DU_AN = $request->get('P_XEM_CV_DA') != 'undefined' ?  $request->get('P_XEM_CV_DA') :  $request->get('P_ID_DU_AN').'.0';
                $P_ID_ND = $request->get('P_THEM_CV_DA') != 'undefined' ?  $request->get('P_THEM_CV_DA') :  $request->get('P_ID_DU_AN').'.0';
                $P_ID_DU_AN = $request->get('P_SUA_CV_DA') != 'undefined' ?  $request->get('P_SUA_CV_DA') :  $request->get('P_ID_DU_AN').'.0';
                $P_ACTION = 1;
                $result = $this->CallFunction($P_ID_DU_AN, $P_ID_ND, $P_XEM_CV_DA, $P_THEM_CV_DA, $P_SUA_CV_DA, $P_ACTION);
                if($result == 1)
                {
                    return response()->json([
                        'success' => true,
                        'message' => 'Thêm nhân viên vào dự án thành công',
                        'status' => 200
                    ], 200);
                }
                else
                {
                    return response()->json([
                        'success' => false,
                        'message' => 'Nhân viên đã tồn tại',
                        'status' => 400
                    ], 200);
                }
            }
        }
    }

 
    public function show(Request $request,$id)
    {
        if($request->has('api_token'))
        {
            $users = DB::SELECT("SELECT ND.*, NV_DA.ID_DU_AN FROM TB_NHAN_VIEN_DA NV_DA, TB_NGUOI_DUNG ND WHERE ND_DA.ID_ND = ND.ID_ND AND NV_DA.ID_DU_AN = $id");
            return response()->json($user, 200);
        }
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
