<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use PDO;
class CustomerController extends Controller
{
    public function CallFunction($p_id_khach_hang, $p_ten_kh, $p_dia_chi_kh, $p_sdt_kh, $p_nguoi_dai_dien, $p_trang_thai_kh, $p_action)
    {
        $sql = "DECLARE
            P_ID_KHACH_HANG number(10);
            P_TEN_KH varchar2(200);
            P_DIA_CHI_KH varchar2(200);
            P_SDT_KH varchar2(200);
            P_NGUOI_DAI_DIEN varchar2(200);
            p_trang_thai_kh number(1);
            p_action number(1);
        BEGIN
            :result := THEM_CAPNHAT_KH(:P_ID_KHACH_HANG,:P_TEN_KH,:P_DIA_CHI_KH,:P_SDT_KH,:P_NGUOI_DAI_DIEN,:P_TRANG_THAI_KH, :P_ACTION);
        END;";
       
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_KHACH_HANG',$p_id_khach_hang);
        $stmt->bindParam(':P_TEN_KH',$p_ten_kh);
        $stmt->bindParam(':P_DIA_CHI_KH',$p_dia_chi_kh);
        $stmt->bindParam(':P_SDT_KH',$p_sdt_kh);
        $stmt->bindParam(':P_NGUOI_DAI_DIEN',$p_nguoi_dai_dien);
        $stmt->bindParam(':P_TRANG_THAI_KH',$p_trang_thai_kh);
        $stmt->bindParam(':P_ACTION',$p_action);
        $stmt->bindParam(':result',$result, PDO::PARAM_INT);
        // return response()->json($stmt, 200);
        $stmt->execute();
        return $result;
    }
    public function index(Request $request)
    {
        if($request->has('api_token'))
        {
            // //CHECK TOKEN ADN RULE
            // $customers = DB::select("SELECT * FROM TB_KH order by CREATED_AT DESC");
            // return response()->json([
            //     'success' => true,
            //     'message' => 'Danh sách khách hàng',
            //     'results' => $customers
            // ], 200);
            $token = $request->get('api_token');
            $result = DB::connection('ora_db')->select('exec 
            SELECT_DS_KH(?)',array($token));
            return response()->json($result, 200);
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
            if($request->has('TEN_KH') && $request->has('DIA_CHI_KH') && $request->has('SDT_KH') &&
                $request->has('NGUOI_DAI_DIEN_KH') && $request->has('TRANG_THAI_KH'))
            {
               
                $p_id_khach_hang = 0;
                $p_ten_kh = $request->get('TEN_KH');
                $p_dia_chi_kh = $request->get('DIA_CHI_KH');
                $p_sdt_kh = $request->get('SDT_KH');
                $p_nguoi_dai_dien = $request->get('NGUOI_DAI_DIEN_KH');
                $p_trang_thai_kh = $request->get('TRANG_THAI_KH');
                $p_action = 1;
                $result = $this->CallFunction($p_id_khach_hang, $p_ten_kh, $p_dia_chi_kh, $p_sdt_kh, $p_nguoi_dai_dien, $p_trang_thai_kh, $p_action);
                return response()->json([
                    'success' => true,
                    'message' => 'Thêm khách hàng mới thành công',
                    'result' => '',
                    'status' => 200
                ], 200);
            }
            // }
            //     $p_id_khach_hang = 0;
            //     $p_ten_kh = $request->get('TEN_KH');
            //     $p_dia_chi_kh = $request->get('DIA_CHI_KH');
            //     $p_sdt_kh = $request->get('SDT_KH');
            //     $p_nguoi_dai_dien = $request->get('NGUOI_DAI_DIEN_KH');
            //     $p_trang_thai_kh = $request->get('TRANG_THAI_KH');
            //     $p_action = 1;
            //     $result = $this->CallFunction($p_id_khach_hang, $p_ten_kh, $p_dia_chi_kh, $p_sdt_kh, $p_nguoi_dai_dien, $p_trang_thai_kh, $p_action);
            //     return response()->json([
            //         'success' => true,
            //         'message' => 'Thêm khách hàng mới thành công',
            //         'result' => $result,
            //         'status' => 200
            //     ], 200);
            return response()->json([
                'success' => false,
                'message' => 'Lỗi tham số',
                'result' => $request->all(),
                'status' => 400
            ], 200);
        }
        return response()->json([
            'success' => false,
            'message' => 'Bạn không có quyền để tạo khách hàng từ hệ thống',
            'result' => '',
            'status' => 401
        ], 200);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function search(Request $request)
    {
        if($request->has('api_token'))
        {
            //CHECK TOKEN
            $search = $request->get('ten_kh');
            $customers = DB::SELECT("SELECT ID_KHACH_HANG, TEN_KH FROM TB_KH WHERE TEN_KH LIKE '%$search%'");
            return response()->json($customers, 200);
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
        if($request->has('api_token'))
        {

            if($request->has('TEN_KH') && $request->has('DIA_CHI_KH') && $request->has('SDT_KH') &&
                $request->has('NGUOI_DAI_DIEN_KH') && $request->has('TRANG_THAI_KH'))
            {
               
                $p_id_khach_hang = $id;
                $p_ten_kh = $request->get('TEN_KH');
                $p_dia_chi_kh = $request->get('DIA_CHI_KH');
                $p_sdt_kh = $request->get('SDT_KH');
                $p_nguoi_dai_dien = $request->get('NGUOI_DAI_DIEN_KH');
                $p_trang_thai_kh = $request->get('TRANG_THAI_KH');
                $p_action = 2;
                $result = $this->CallFunction($p_id_khach_hang, $p_ten_kh, $p_dia_chi_kh, $p_sdt_kh, $p_nguoi_dai_dien, $p_trang_thai_kh, $p_action);
                return response()->json([
                    'success' => true,
                    'message' => 'Cập nhật khách hàng mới thành công',
                    'result' => '',
                    'status' => 200
                ], 200);
            }
            return response()->json([
                'success' => false,
                'message' => 'Lỗi tham số',
                'result' => '',
                'status' => 400
            ], 200);
        }
        return response()->json([
            'success' => false,
            'message' => 'Bạn không có quyền để tạo khách hàng từ hệ thống',
            'result' => '',
            'status' => 401
        ], 200);
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
