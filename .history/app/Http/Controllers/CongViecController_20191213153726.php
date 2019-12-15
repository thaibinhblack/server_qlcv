<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DateTime;
use DB;
use PDO;
class CongViecController extends Controller
{
    public function CallFunction($P_ID_CV_DA,
                $P_TEN_CV ,
                $P_NOI_DUNG_CV ,
                $P_NGAY_TIEP_NHAN ,
                $P_NGAY_HOAN_THANH ,
                $P_NGAY_CAM_KET,
                $P_GIO_THUC_HIEN ,
                $P_DO_UU_TIEN,
                $P_MA_JIRA ,
                $P_NGUOI_GIAO_VIEC ,
                $P_NGUOI_NHAN_VIEC ,
                $P_TIEN_DO ,
                $P_GHI_CHU ,
                $P_LY_DO ,
                $P_THAM_DINH_TGIAN ,
                $P_THAM_DINH_KHOI_LUONG,
                $P_THAM_DINH_CHAT_LUONG,
                $P_ID_LOAI_CV,
                $P_TRANG_THAI,
                $P_ACTION,
                $P_TYPE,
                $P_NGUOI_NHAP
    )
    {
     $sql = "DECLARE
        P_ID_CV_DA NUMBER;
        P_TEN_CV VARCHAR2(255);
        P_NOI_DUNG_CV VARCHAR2(255);
        P_NGAY_TIEP_NHAN DATE;
        P_NGAY_HOAN_THANH DATE;
        P_NGAY_CAM_KET DATE;
        P_GIO_THUC_HIEN NUMBER;
        P_DO_UU_TIEN NUMBER;
        P_MA_JIRA VARCHAR2(255);
        P_NGUOI_GIAO_VIEC VARCHAR2(255);
        P_NGUOI_NHAN_VIEC VARCHAR2(255);
        P_TIEN_DO NUMBER;
        P_GHI_CHU VARCHAR2(255);
        P_LY_DO VARCHAR2(255);
        P_THAM_DINH_TGIAN DATE;
        P_THAM_DINH_KHOI_LUONG NUMBER;
        P_THAM_DINH_CHAT_LUONG NUMBER;
        P_ID_LOAI_CV NUMBER;
        P_TRANG_THAI NUMBER;
        P_ACTION NUMBER;
        P_TYPE NUMBER;
        P_NGUOI_NHAP VARCHAR2(100);
    BEGIN
       :RESULT_CV := THEM_CAPNHAT_CONGVIEC(:P_ID_CV_DA, :P_TEN_CV, :P_NOI_DUNG_CV, :P_NGAY_TIEP_NHAN,:P_NGAY_HOAN_THANH, :P_NGAY_CAM_KET, :P_GIO_THUC_HIEN, :P_DO_UU_TIEN, 
    :P_MA_JIRA, :P_NGUOI_GIAO_VIEC, :P_NGUOI_NHAN_VIEC, :P_TIEN_DO, :P_GHI_CHU, :P_LY_DO, :P_THAM_DINH_TGIAN, :P_THAM_DINH_KHOI_LUONG, :P_THAM_DINH_CHAT_LUONG, :P_ID_LOAI_CV, 
    :P_TRANG_THAI, :P_ACTION, :P_TYPE, :P_NGUOI_NHAP);
    END;";  
    $pdo = DB::getPdo();
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':P_ID_CV_DA',$P_ID_CV_DA);
    $stmt->bindParam(':P_TEN_CV',$P_TEN_CV);
    $stmt->bindParam(':P_NOI_DUNG_CV',$P_NOI_DUNG_CV);
    $stmt->bindParam(':P_NGAY_TIEP_NHAN',$P_NGAY_TIEP_NHAN);
    $stmt->bindParam(':P_NGAY_HOAN_THANH',$P_NGAY_HOAN_THANH);
    $stmt->bindParam(':P_NGAY_CAM_KET',$P_NGAY_CAM_KET);
    $stmt->bindParam(':P_GIO_THUC_HIEN',$P_GIO_THUC_HIEN);
    $stmt->bindParam(':P_DO_UU_TIEN',$P_DO_UU_TIEN);
    $stmt->bindParam(':P_MA_JIRA',$P_MA_JIRA);
    $stmt->bindParam(':P_NGUOI_GIAO_VIEC',$P_NGUOI_GIAO_VIEC);
    $stmt->bindParam(':P_NGUOI_NHAN_VIEC',$P_NGUOI_NHAN_VIEC);
    $stmt->bindParam(':P_TIEN_DO',$P_TIEN_DO);
    $stmt->bindParam(':P_GHI_CHU',$P_GHI_CHU);
    $stmt->bindParam(':P_LY_DO',$P_LY_DO);
    $stmt->bindParam(':P_THAM_DINH_TGIAN',$P_THAM_DINH_TGIAN);
    $stmt->bindParam(':P_THAM_DINH_KHOI_LUONG',$P_THAM_DINH_KHOI_LUONG);
    $stmt->bindParam(':P_THAM_DINH_CHAT_LUONG',$P_THAM_DINH_CHAT_LUONG);
    $stmt->bindParam(':P_ID_LOAI_CV',$P_ID_LOAI_CV);
    $stmt->bindParam(':P_TRANG_THAI',$P_TRANG_THAI);
    $stmt->bindParam(':P_ACTION',$P_ACTION);
    $stmt->bindParam(':P_TYPE',$P_TYPE);
    $stmt->bindParam(':P_NGUOI_NHAP',$P_NGUOI_NHAP);
    $stmt->bindParam(':RESULT_CV',$result, PDO::PARAM_INT);
    $stmt->execute();
    return $result;
    }

    public function index(Request $request)
    {
        if($request->has('api_token'))
        {
            $token = $request->get('api_token');
            $user = DB::SELECT("SELECT id_nd from TB_NGUOI_DUNG WHERE TOKEN_ND = '$token'");
            $id_nd = $user[0]->id_nd;
            if($request->has('trang_thai'))
            {
                $trang_thai = $request->get('trang_thai');
                $cv = DB::select("SELECT CVDA.*, ND.username_nd, LCV.ten_loai_cv FROM TB_CONG_VIEC_DA CVDA, TB_NGUOI_DUNG ND, TB_LOAI_CV LCV where CVDA.nguoi_giao_viec = ND.id_nd and nguoi_nhan_viec = '$id_nd' and CVDA.trang_thai = $trang_thai and CVDA.id_loai_cv = LCV.id_loai_cv");
                return response()->json($cv, 200);
            }
            $cv = DB::select("SELECT CVDA.*, ND.username_nd FROM TB_CONG_VIEC_DA CVDA, TB_NGUOI_DUNG ND where CVDA.nguoi_giao_viec = ND.id_nd and nguoi_nhan_viec = '$id_nd' ");
            return response()->json($cv, 200);
        }
        // $cong_viec = DB::select("SELECT * FROM TB_CONG_VIEC_DA");
        // return response()->json($cong_viec, 200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        if($request->has('P_TEN_CV') && $request->has('P_TRANG_THAI') &&  $request->has('P_ID_LOAI_CV') 
            && $request->has('P_DO_UU_TIEN') && $request->has('P_NGUOI_NHAP') )
        {
            if($request->has('api_token'))
            {
                $P_ID_CV_DA = $request->get('P_ACTION') == 1 ? 0 : $request->get('P_ID_CV_DA');
                // $P_ID_DU_AN_KH = $request->get("P_ID_DU_AN_KH");
                $P_TEN_CV = $request->get('P_TEN_CV');
                $P_NGAY_TIEP_NHAN = $request->get('P_NGAY_TIEP_NHAN');
                $P_NGAY_HOAN_THANH = $request->get('P_NGAY_HOAN_THANH');
                $P_NGUOI_GIAO_VIEC = $request->get('P_NGUOI_GIAO_VIEC');
                $P_TRANG_THAI = $request->get('P_TRANG_THAI');
                $P_DO_UU_TIEN = $request->get('P_DO_UU_TIEN');
                $P_NOI_DUNG_CV = $request->get('P_NOI_DUNG_CV') != 'undefined' ?  $request->get('P_NOI_DUNG_CV') : ''; 
                $P_NGAY_CAM_KET = $request->get('P_NGAY_CAM_KET') != 'undefined' ?  $request->get('P_NGAY_CAM_KET') : NULL; 
                $P_GIO_THUC_HIEN =  $request->get('P_GIO_THUC_HIEN') != 'undefined' ?  $request->get('P_GIO_THUC_HIEN') : NULL; 
                $P_MA_JIRA = $request->get('P_MA_JIRA') != 'undefined' ?  $request->get('P_MA_JIRA') : NULL; 
                $P_NGUOI_NHAN_VIEC = $request->get('P_NGUOI_NHAN_VIEC') != 'undefined' ?  $request->get('P_NGUOI_NHAN_VIEC') : NULL; 
                $P_TIEN_DO = $request->get('P_TIEN_DO') != 'undefined' ?  $request->get('P_TIEN_DO') : NULL; 
                $P_GHI_CHU =  $request->get('P_GHI_CHU') != 'undefined' ?  $request->get('P_GHI_CHU') : NULL; 
                $P_LY_DO =  $request->get('P_LY_DO') != 'undefined' ?  $request->get('P_LY_DO') : NULL; 
                $P_THAM_DINH_TGIAN  =  $request->get('P_THAM_DINH_TGIAN') != 'undefined' ?  $request->get('P_THAM_DINH_TGIAN') : NULL; 
                $P_THAM_DINH_KHOI_LUONG =  $request->get('P_THAM_DINH_KHOI_LUONG') != 'undefined' ?  $request->get('P_THAM_DINH_KHOI_LUONG') : NULL; 
                $P_THAM_DINH_CHAT_LUONG =  $request->get('P_THAM_DINH_CHAT_LUONG') != 'undefined' ?  $request->get('P_THAM_DINH_CHAT_LUONG') : NULL; 
                $P_ID_LOAI_CV =  $request->get('P_ID_LOAI_CV') != 'undefined' ?  $request->get('P_ID_LOAI_CV') : 1; 
                $P_TYPE = $request->get('P_TYPE');
                $P_ACTION = $request->get('P_ACTION');
                $P_NGUOI_NHAP = $request->get('P_NGUOI_NHAP');
                $result = $this->CallFunction($P_ID_CV_DA,
                $P_TEN_CV ,
                $P_NOI_DUNG_CV ,
                $P_NGAY_TIEP_NHAN ,
                $P_NGAY_HOAN_THANH ,
                $P_NGAY_CAM_KET,
                $P_GIO_THUC_HIEN ,
                $P_DO_UU_TIEN,
                $P_MA_JIRA ,
                $P_NGUOI_GIAO_VIEC ,
                $P_NGUOI_NHAN_VIEC ,
                $P_TIEN_DO ,
                $P_GHI_CHU ,
                $P_LY_DO ,
                $P_THAM_DINH_TGIAN ,
                $P_THAM_DINH_KHOI_LUONG,
                $P_THAM_DINH_CHAT_LUONG,
                $P_ID_LOAI_CV,
                $P_TRANG_THAI,
                $P_ACTION,
                $P_TYPE,
                $P_NGUOI_NHAP);
                return response()->json([
                    'success' => true,
                    'message' => 'Thêm công việc thành công',
                    'results' => $result,
                    'status' => 200
                ], 200);
            }
            else
            {
                return response()->json([
                    'success' => true,
                    'message' => 'Không có quyền này',
                    'status' => 401
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
    public function show(Request $request,$id,$id_du_an)
    {
        if($request->has('api_token'))
        {
            if($id == 0)
            {
                if($id_du_an == 0)
                {
                    $cong_viec = DB::select("SELECT CV.*, DA_KH.TEN_DU_AN_KH FROM TB_CONG_VIEC_DA CV, TB_CONG_VIEC_DA_KH CV_KH, TB_DU_AN_KH DA_KH  WHERE CV.ID_CV_DA = CV_KH.ID_CV_DA AND CV_KH.ID_DU_AN_KH = DA_KH.ID_DU_AN_KH");
                    return response()->json($cong_viec, 200);
                }
                else {
                    $cong_viec = DB::select("SELECT CV.*, DA_KH.TEN_DU_AN_KH FROM TB_CONG_VIEC_DA CV, TB_CONG_VIEC_DA_KH CV_KH, TB_DU_AN_KH DA_KH  WHERE CV.ID_CV_DA = CV_KH.ID_CV_DA AND CV_KH.ID_DU_AN_KH = DA_KH.ID_DU_AN_KH AND DA_KH.id_du_an = $id_du_an");
                    return response()->json($cong_viec, 200);
                }
            }
            else {
                if($id == -1)
                {
                    $cong_viec = DB::select("SELECT *
                    FROM tb_cong_viec_da
                    WHERE not EXISTS (SELECT *
                                  FROM tb_cong_viec_da_kh
                                  WHERE tb_cong_viec_da.id_cv_da = tb_cong_viec_da_kh.id_cv_da) ");
                    return response()->json($cong_viec, 200);
                }
                else {
                    $cong_viec = DB::select("SELECT CV.* FROM TB_CONG_VIEC_DA CV, TB_CONG_VIEC_DA_KH CV_KH WHERE CV.ID_CV_DA = CV_KH.ID_CV_DA AND CV_KH.ID_DU_AN_KH = $id");
                    return response()->json($cong_viec, 200);
                }
            }
            
        }
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function capnhat_congviec(Request $request,$id)
    {
                $P_ID_CV_DA = $id;
                $P_TEN_CV = NULL;
                $P_NGAY_TIEP_NHAN = NULL;
                $P_NGAY_HOAN_THANH = NULL;
                $P_NGUOI_GIAO_VIEC = NULL;
                $P_TRANG_THAI = NULL;
                $P_DO_UU_TIEN = NULL;
                $P_NOI_DUNG_CV = NULL; 
                $P_NGAY_CAM_KET = $request->get("P_NGAY_CAM_KET"); 
                $P_GIO_THUC_HIEN =  NULL; 
                $P_MA_JIRA = NULL; 
                $P_NGUOI_NHAN_VIEC =NULL; 
                $P_TIEN_DO = $request->get('P_TIEN_DO'); 
                $P_GHI_CHU =  NULL; 
                $P_LY_DO = NULL; 
                $P_THAM_DINH_TGIAN  =  NULL; 
                $P_THAM_DINH_KHOI_LUONG = NULL; 
                $P_THAM_DINH_CHAT_LUONG =  NULL; 
                $P_ID_LOAI_CV =  NULL; 
                $P_ACTION = 2;
                $P_TYPE = $request->get('P_TYPE');
                $P_NGUOI_NHAP = null;
                $result = $this->CallFunction($P_ID_CV_DA,
                    $P_TEN_CV ,
                    $P_NOI_DUNG_CV ,
                    $P_NGAY_TIEP_NHAN ,
                    $P_NGAY_HOAN_THANH ,
                    $P_NGAY_CAM_KET,
                    $P_GIO_THUC_HIEN ,
                    $P_DO_UU_TIEN,
                    $P_MA_JIRA ,
                    $P_NGUOI_GIAO_VIEC ,
                    $P_NGUOI_NHAN_VIEC ,
                    $P_TIEN_DO ,
                    $P_GHI_CHU ,
                    $P_LY_DO ,
                    $P_THAM_DINH_TGIAN ,
                    $P_THAM_DINH_KHOI_LUONG,
                    $P_THAM_DINH_CHAT_LUONG,
                    $P_ID_LOAI_CV,
                    $P_TRANG_THAI,
                    $P_ACTION,
                    $P_TYPE,
                    $P_NGUOI_NHAP);
                return response()->json([
                    'success' => true,
                    'message' => 'Cập công việc thành công',
                    'status' => 200
                ], 200);
            
    }
    public function update(Request $request, $id)
    {
        if($request->has('api_token'))
            {
                $P_ID_CV_DA = $id;
                $P_TEN_CV = NULL;
                $P_NGAY_TIEP_NHAN = NULL;
                $P_NGAY_HOAN_THANH = NULL;
                $P_NGUOI_GIAO_VIEC = NULL;
                $P_TRANG_THAI = $request->get('trang_thai');
                $P_DO_UU_TIEN = NULL;
                $P_NOI_DUNG_CV = NULL; 
                $P_NGAY_CAM_KET = NULL; 
                $P_GIO_THUC_HIEN =  NULL; 
                $P_MA_JIRA = NULL; 
                $P_NGUOI_NHAN_VIEC =NULL; 
                $P_TIEN_DO = NULL; 
                $P_GHI_CHU =  NULL; 
                $P_LY_DO = NULL; 
                $P_THAM_DINH_TGIAN  =  NULL; 
                $P_THAM_DINH_KHOI_LUONG = NULL; 
                $P_THAM_DINH_CHAT_LUONG =  NULL; 
                $P_TRANG_THAI_LTRINH =  NULL; 
                $P_ACTION = 3;
                $P_TYPE = $request->get('P_TYPE');
                $P_NGUOI_NHAP = null;
                $result = $this->CallFunction($P_ID_CV_DA,
                    $P_TEN_CV ,
                    $P_NOI_DUNG_CV ,
                    $P_NGAY_TIEP_NHAN ,
                    $P_NGAY_HOAN_THANH ,
                    $P_NGAY_CAM_KET,
                    $P_GIO_THUC_HIEN ,
                    $P_DO_UU_TIEN,
                    $P_MA_JIRA ,
                    $P_NGUOI_GIAO_VIEC ,
                    $P_NGUOI_NHAN_VIEC ,
                    $P_TIEN_DO ,
                    $P_GHI_CHU ,
                    $P_LY_DO ,
                    $P_THAM_DINH_TGIAN ,
                    $P_THAM_DINH_KHOI_LUONG,
                    $P_THAM_DINH_CHAT_LUONG,
                    $P_TRANG_THAI_LTRINH,
                    $P_TRANG_THAI,
                    $P_ACTION,
                    $P_TYPE,
                    $P_NGUOI_NHAP);
                return response()->json([
                    'success' => true,
                    'message' => 'Cập công việc thành công',
                    'status' => 200
                ], 200);
            }
    }

    public function chitiet(Request $request)
    {
        $sql = "DECLARE
            P_ID_DU_AN_KH number;
            P_ID_CV_DA number;
            P_ACTION number(1);
        BEGIN
            :result := THEM_CAPNHAT_CVDA(:P_ID_DU_AN_KH,:P_ID_CV_DA,:P_ACTION);
        END;";
        $P_ID_CV_DA = $request->get('P_ID_CV_DA');
        $P_ID_DU_AN_KH = $request->get('P_ID_DU_AN_KH');
        $P_ACTION = 1;
        $array = explode(',', $P_ID_DU_AN_KH);
        foreach ($array as $value) {
            $pdo = DB::getPdo();
            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':P_ID_DU_AN_KH',$value,PDO::PARAM_INT);
            $stmt->bindParam(':P_ID_CV_DA',$P_ID_CV_DA,PDO::PARAM_INT);
            $stmt->bindParam(':P_ACTION',$P_ACTION);
            $stmt->bindParam(':result',$result);
            $stmt->execute();
        }
       
        // return response()->json($stmt, 200);
        
        return $result;
    }

    public function get_baocao($id)
    {
        $baocao = DB::SELECT("SELECT BAOCAO.* , ND.DISPLAY_NAME  FROM TB_BAOCAO_CV BAOCAO, TB_NGUOI_DUNG ND WHERE BAOCAO.ID_CV = $id AND BAOCAO.ID_ND = ND.ID_ND");
        return response()->json($baocao, 200);
    }

    public function baocao(Request $request, $id)
    {
        if($request->has('api_token'))
        {
            //check user
            $sql = "DECLARE
                P_ID_CV number;
                P_TIEN_DO number;
                P_TRANG_THAI number;
                P_ID_ND number;
                P_NOI_DUNG_BAOCAO varchar2(255);
                P_ACTION number(1);
            BEGIN
                :result := THEM_CAPNHAT_BAOCAO(:P_ID_CV, :P_TIEN_DO, :P_TRANG_THAI, :P_ID_ND, :P_NOI_DUNG_BAOCAO,:P_ACTION);
            END;";
            $P_ID_CV = $id;
            $P_TIEN_DO = $request->get('P_TIEN_DO');
            $P_TRANG_THAI = $request->get('P_TRANG_THAI');
            $P_ID_ND = $request->get('P_ID_ND');
            $P_NOI_DUNG_BAOCAO = $request->get('P_NOI_DUNG_BAOCAO');
            $P_ACTION = 1;
            $pdo = DB::getPdo();
            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':P_ID_CV',$id,PDO::PARAM_INT);
            $stmt->bindParam(':P_TIEN_DO', $P_TIEN_DO,PDO::PARAM_INT);
            $stmt->bindParam(':P_TRANG_THAI',$P_TRANG_THAI);
            $stmt->bindParam(':P_ID_ND',$P_ID_ND,PDO::PARAM_INT);
            $stmt->bindParam(':P_NOI_DUNG_BAOCAO',$P_NOI_DUNG_BAOCAO);
            $stmt->bindParam(':P_ACTION',$P_ACTION);
            $stmt->bindParam(':result',$result);
            $stmt->execute();
            if($result == 1)
            {
                return response()->json([
                    'success' => true,
                    'message' => 'Báo cáo công việc thành công',
                    'status' => 200
                ], 200);
            }
        }
    }

    public function destroy($id)
    {
        //
    }
}
