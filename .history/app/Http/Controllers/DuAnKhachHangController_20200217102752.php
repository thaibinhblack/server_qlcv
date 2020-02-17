<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use PDO;
use App\model\DuAnKHModel;
class DuAnKhachHangController extends Controller
{
    public function CallFunction($P_ID_DU_AN_KH, $P_ID_DU_AN, $P_TEN_DU_AN_KH, $P_MO_TA_DU_AN, $P_GHI_CHU_DU_AN, $P_TRANG_THAI_DU_AN, $P_ID_KHACH_HANG, $P_ACTION)
    {
        $sql = "DECLARE
            P_ID_DU_AN_KH NUMBER(10);
            P_ID_DU_AN NUMBER(10);
            P_TEN_DU_AN_KH VARCHAR2(50);
            P_MO_TA_DU_AN VARCHAR2(255);
            P_GHI_CHU_DU_AN VARCHAR2(255);
            P_TRANG_THAI_DU_AN NUMBER(1);
            P_ID_KHACH_HANG NUMBER(10);
            P_ACTION NUMBER(1);
        BEGIN
            :n := THEM_UPDATE_DU_AN_KH(:P_ID_DU_AN_KH, :P_ID_DU_AN, :P_TEN_DU_AN_KH, :P_MO_TA_DU_AN, :P_GHI_CHU_DU_AN,:P_TRANG_THAI_DU_AN, :P_ID_KHACH_HANG, :P_ACTION);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_DU_AN_KH',$P_ID_DU_AN_KH);
        $stmt->bindParam(':P_ID_DU_AN',$P_ID_DU_AN);
        $stmt->bindParam(':P_TEN_DU_AN_KH',$P_TEN_DU_AN_KH);
        $stmt->bindParam(':P_MO_TA_DU_AN',$P_MO_TA_DU_AN);
        $stmt->bindParam(':P_GHI_CHU_DU_AN',$P_GHI_CHU_DU_AN);
        $stmt->bindParam(':P_TRANG_THAI_DU_AN',$P_TRANG_THAI_DU_AN);
        $stmt->bindParam(':P_ID_KHACH_HANG',$P_ID_KHACH_HANG);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':n',$result);
        $stmt->execute();
        return $result;
    }

    public function CallFunctionTrangThai($P_ID_TRANG_THAI, $P_TEN_TRANG_THAI, $P_NOI_DUNG_TRANG_THAI, $P_GHI_CHU_TRANG_THAI, $P_ACTION)
    {
        $sql = "DECLARE
            P_ID_TRANG_THAI NUMBER;
            P_TEN_TRANG_THAI VARCHAR2(255);
            P_NOI_DUNG_TRANG_THAI VARCHAR2(255);
            P_GHI_CHU_TRANG_THAI VARCHAR2(255);
            P_ACTION NUMBER(1);
        BEGIN
            :result := THEM_CAPNHAT_TT_DUAN_KH(:P_ID_TRANG_THAI, :P_TEN_TRANG_THAI, :P_NOI_DUNG_TRANG_THAI, :P_GHI_CHU_TRANG_THAI,:P_ACTION);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_TRANG_THAI',$P_ID_TRANG_THAI,  PDO::PARAM_INT);
        $stmt->bindParam(':P_TEN_TRANG_THAI',$P_TEN_TRANG_THAI);
        $stmt->bindParam(':P_NOI_DUNG_TRANG_THAI',$P_NOI_DUNG_TRANG_THAI);
        $stmt->bindParam(':P_GHI_CHU_TRANG_THAI',$P_GHI_CHU_TRANG_THAI);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':result',$result, PDO::PARAM_INT);
        $stmt->execute();
        return $result;
    }

    public function CallFunctionQuyen($P_ID_QUYEN_DA, $P_ID_ND, $P_ID_DU_AN, $P_Q_XEM, $P_Q_THEM, $P_Q_SUA, $P_Q_XOA, $P_Q_XUAT, $P_ACTION)
    {
        $sql = "DECLARE
            P_ID_QUYEN_DA NUMBER;
            P_ID_ND NUMBER;
            P_ID_DU_AN NUMBER;
            P_Q_XEM VARCHAR2(20);
            P_Q_THEM VARCHAR2(20);
            P_Q_SUA VARCHAR2(20);
            P_Q_XOA VARCHAR2(20);
            P_Q_XUAT VARCHAR2(20);
            P_ACTION NUMBER;
        BEGIN
            :n := THEM_CAPNHAT_QUYEN_DUAN(:P_ID_QUYEN_DA, :P_ID_ND, :P_ID_DU_AN, :P_Q_XEM, :P_Q_THEM,:P_Q_SUA, :P_Q_XOA, :P_Q_XUAT,:P_ACTION);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_QUYEN_DA',$P_ID_QUYEN_DA);
        $stmt->bindParam(':P_ID_ND',$P_ID_ND);
        $stmt->bindParam(':P_ID_DU_AN',$P_ID_DU_AN);
        $stmt->bindParam(':P_Q_XEM',$P_Q_XEM);
        $stmt->bindParam(':P_Q_THEM',$P_Q_THEM);
        $stmt->bindParam(':P_Q_SUA',$P_Q_SUA);
        $stmt->bindParam(':P_Q_XOA',$P_Q_XOA);
        $stmt->bindParam(':P_Q_XUAT',$P_Q_XUAT);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':n',$result, PDO::PARAM_INT);
        $stmt->execute();
        return $result;
    }

    public function index(Request $request)
    {
        if($request->has('api_token'))
        {
            //CHECK TOKEN
            $du_an_kh_model = new DuAnKHModel();
           if($request->has('id_du_an'))
           {
            $du_an_kh = $du_an_kh_model->SELECT_DU_AN_KH($request->get("id_du_an"));
            return response()->json($du_an_kh, 200);
           }
           $du_an_kh = $du_an_kh_model->SELECT_DU_AN_KH(0);
            return response()->json($du_an_kh, 200);
        }
    }
    
    public function nhanvien_duan(Request $request)
    {
        if($request->get('api_token'))
        {
            if($request->get('id_du_an_kh'))
            {
                $id_du_an_kh = $request->get('id_du_an_kh');
                $users = DB::SELECT("SELECT QUYEN.*, ND.username_nd, ND.id_nd FROM TB_QUYEN_DA QUYEN, TB_NGUOI_DUNG ND WHERE ID_DU_AN = $id_du_an_kh and QUYEN.ID_ND = ND.ID_ND");
                return response()->json($users, 200);
            }
        }
    }
    public function store(Request $request)
    {
        // $validate  = $this->validate($request,[
        //     'P_TEN_DU_AN_KH' => 'required|max:50',
        //     'P_ID_DU_AN' => 'required|max:1',
        //     'P_TRANG_THAI_DU_AN' => 'required|max:1'
        // ]);
        if($request->has('P_TEN_DU_AN_KH') && $request->has('P_ID_DU_AN') && $request->has('P_TRANG_THAI_DU_AN'))
        {
            if($request->has('api_token'))
            {
                $TOKEN = $request->get('api_token');
                $user = DB::SELECT("SELECT id_nd from TB_NGUOI_DUNG WHERE TOKEN_ND = '$TOKEN'");
                $arr_params = [
                    "P_ID_DU_AN_KH" => 0,
                    "P_ID_DU_AN" => $request->get('P_ID_DU_AN') ,
                    "P_TEN_DU_AN_KH" => $request->get('P_TEN_DU_AN_KH') ,
                    "P_MO_TA_DU_AN" => $request->get('P_MO_TA_DU_AN') != 'undefined' ? $request->get('P_MO_TA_DU_AN') : 'NULL' ,
                    "P_GHI_CHU_DU_AN" =>  $request->get('P_GHI_CHU_DU_AN') != 'undefined'  ? $request->get('P_GHI_CHU_DU_AN') : 'NULL' ,
                    "P_ID_KHACH_HANG" =>  $request->get('P_ID_KHACH_HANG') != 'undefined'  ? $request->get('P_ID_KHACH_HANG') : NULL ,
                    "P_TRANG_THAI_DU_AN" => $request->get('P_TRANG_THAI_DU_AN') ,
                    "P_ACTION" => 1,
                    "P_TRANG_THAI_LT" => 0
                ];
                // $result =1 ;
                $du_an_kh_model = new DuAnKHModel();

                $result = $du_an_kh_model->THEM_UPDATE_DU_AN_KH($arr_params);
                if($result)
                {
                    $ID_DU_AN_KH = DB::SELECT("SELECT  max(id_du_an_kh) AS ID_DU_AN_KH from tb_du_an_kh");
                    // return response()->json($ID_DU_AN_KH, 200);
                    $KQ = $this->CallFunctionQuyen(0,$user[0]->id_nd, $ID_DU_AN_KH[0]->id_du_an_kh, $ID_DU_AN_KH[0]->id_du_an_kh.'.1', $ID_DU_AN_KH[0]->id_du_an_kh.'.2', $ID_DU_AN_KH[0]->id_du_an_kh.'.3', $ID_DU_AN_KH[0]->id_du_an_kh.'.4', $ID_DU_AN_KH[0]->id_du_an_kh.'.5',1 );
                    return response()->json([
                        'success' => true,
                        'message' => 'Thêm dự án',
                        'result' => $KQ,
                        'status' => 200
                    ], 200);
                }
                return response()->json([
                    'success' =>  false,
                    'message' => 'Thêm dự án thất bại',
                    'result' => '',
                    'status' => 200
                ], 200);
                
            }
        }
        return response()->json([
            'success' => false,
            'message' => 'Lỗi'
        ], 200);
    }

    public function destroy(Request $request,$id_cv_da,$id_du_an_kh)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->CHECK_TOKEN($request->get('api_token'));
            if($user)
            {
                $du_an_kh_model = new DuAnKHModel();
                $du_an_kh = $du_an_kh_model->DELETE_CONG_VIEC_DAKH($id_cv_da,$id_du_an_kh);
                return response()->json([
                    'success' => true,
                    'message' => 'Xóa công việc của dự án thành công',
                    'result' => $du_an_kh,
                    'status' => 200
                ], 200);
            }
            return response()->json([
                'success' => false,
                'message' => 'Không thực hiện được chức năng này',
                'result' => null,
                'status' => 404
            ], 200);
        }
        return response()->json([
            'success' => false,
            'message' => 'Không thực hiện được chức năng này',
            'result' => null,
            'status' => 401
        ], 200);
    }
    

    public function themthanhvien(Request $request)
    {
        if($request->has('api_token'))
        {
            
            $array = explode(',', $request->get('array_nv'));
            $id_du_an_kh = $request->get('id_du_an_kh');
            foreach ($array as $value) {
                $check = DB::SELECT("SELECT COUNT(id_nd) as check_nv from TB_QUYEN_DA where ID_ND = $value and ID_DU_AN = $id_du_an_kh");
                if($check[0]->check_nv == 0)
                {
                    $result =$this->CallFunctionQuyen(0,$value, $id_du_an_kh, $id_du_an_kh.'.1', $id_du_an_kh.'.2', $id_du_an_kh.'.3', $id_du_an_kh.'.4', $id_du_an_kh.'.5',1 );
                    return response()->json($result, 200);
                }
                
            }
           
        }
    }

    public function update_quyen_thanhvien(Request $request)
    {
        $id_nd = $request->get('id_nd');
        $id_du_an_kh = $request->get('id_du_an_kh');
        $view = $create = $edit = $delete = $export = $id_du_an_kh.'.0';
        $array = explode(',', $request->get('array_nv'));
        foreach ($array as $value ) {
            if($value == $id_du_an_kh.'.1')
            {
                $view =  $id_du_an_kh.'.1';
            }
            if($value == $id_du_an_kh.'.2')
            {
                $create =  $id_du_an_kh.'.2';
            }
            if($value == $id_du_an_kh.'.3')
            {
                $edit =  $id_du_an_kh.'.3';
            }
            if($value == $id_du_an_kh.'.4')
            {
                $delete =  $id_du_an_kh.'.4';
            }
            if($value == $id_du_an_kh.'.5')
            {
                $export =  $id_du_an_kh.'.5';
            }
            // $result =$this->CallFunctionQuyen($,$value, $id_du_an_kh, $id_du_an_kh.'.1', $id_du_an_kh.'.2', $id_du_an_kh.'.3', $id_du_an_kh.'.4', $id_du_an_kh.'.5',1 );
        }

    }

    public function show_quyen_thanhvien(Request $request)
    {
        if($request->get('api_token'))
        {
            // $validate  = $this->validate($request,[
            //     'id_nd' => 'required',
            //     'id_du_an_kh' => 'required',
            // ]);
            if($request->has('id_nd') && $request->has('id_du_an_Kh'))
            {
                $id_nd = $request->get('id_nd');
                $id_du_an_kh = $request->get('id_du_an_kh');
                $quyen = DB::SELECT("SELECT q_xem,q_them,q_sua,q_xoa,q_xuat FROM TB_QUYEN_DA WHERE id_nd = $id_nd and id_du_an = $id_du_an_kh");
                return response()->json($quyen, 200);
            }
           
        }
    }

    public function show(Request $request,$id){
        if($request->has('api_token'))
        {
            if($request->has('show'))
            {
                if($request->get('show') == 'ID_DU_AN')
                {
                    $du_an_kh_model = new DuAnKHModel();
                    $du_an_kh = $du_an_kh_model->SELECT_DU_AN_KH($id);
                    return response()->json($du_an_kh, 200);
                }
            }
            $du_an = DB::SELECT("SELECT * FROM TB_DU_AN_KH WHERE ID_DU_AN_KH = $id");
            return response()->json($du_an, 200);
        }
    }
    public function update(Request $request, $id)
    {
        // $validate  = $this->validate($request,[
        //     'P_TEN_DU_AN_KH' => 'required|max:50',
        //     'P_ID_DU_AN' => 'required|max:1',
        //     'P_TRANG_THAI_DU_AN' => 'required|max:1'
        // ]);
        if($request->has('P_TEN_DU_AN_KH') && $request->has('P_ID_DU_AN') && $request->has('P_TRANG_THAI_DU_AN'))
        {
            if($request->has('api_token'))
            {
                //CHECK TOKEN
                $arr_params = [
                    "P_ID_DU_AN_KH" => $id,
                    "P_ID_DU_AN" => $request->get('P_ID_DU_AN') ,
                    "P_TEN_DU_AN_KH" => $request->get('P_TEN_DU_AN_KH') ,
                    "P_MO_TA_DU_AN" => $request->get('P_MO_TA_DU_AN') != 'undefined' ? $request->get('P_MO_TA_DU_AN') : 'NULL' ,
                    "P_GHI_CHU_DU_AN" =>  $request->get('P_GHI_CHU_DU_AN') != 'undefined'  ? $request->get('P_GHI_CHU_DU_AN') : 'NULL' ,
                    "P_ID_KHACH_HANG" =>  $request->get('P_ID_KHACH_HANG') != 'undefined'  ? $request->get('P_ID_KHACH_HANG') : NULL ,
                    "P_TRANG_THAI_DU_AN" => $request->get('P_TRANG_THAI_DU_AN') ,
                    "P_ACTION" => 2,
                    "P_TRANG_THAI_LT" => $request->get("P_TRANG_THAI_LT")
                ];
                $du_an_kh_model = new DuAnKHModel();
                $result = $du_an_kh_model->THEM_UPDATE_DU_AN_KH($arr_params);  
                return response()->json([
                    'success' => true,
                    'message' => 'Cập nhật dự án',
                    'result' => $result,
                    'status' => 200
                ], 200);
            }
        }
    }

    //trạng thái dự án khách hàng
    public function index_trang_thai(Request $request)
    {
        $trang_thai = DB::select("SELECT * FROM TB_TRANG_THAI_DU_AN_KH");
        return response()->json($trang_thai, 200);
    }
    public function store_trang_thai(Request $request)
    {
        if($request->has('api_token'))
        {
            $P_ID_TRANG_THAI = 0;
            $P_TEN_TRANG_THAI = $request->get('P_TEN_TRANG_THAI');
            $P_NOI_DUNG_TRANG_THAI = $request->get('P_NOI_DUNG_TRANG_THAI');
            $P_GHI_CHU_TRANG_THAI = $request->get('P_GHI_CHU_TRANG_THAI'); 
            $P_ACTION = 1;
            $result = $this->CallFunctionTrangThai($P_ID_TRANG_THAI, $P_TEN_TRANG_THAI, $P_NOI_DUNG_TRANG_THAI, $P_GHI_CHU_TRANG_THAI, $P_ACTION);
            return response()->json($result, 200);
        }
    }

    public function destroy_trang_thai(Request $request,$id_trang_thai)
    {
        if($request->has('api_token'))
        {
            $result = $this->CallFunctionTrangThai($id_trang_thai,null,null,null,3);
            return response()->json($result, 200);
        }
    }
 

}
