<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;
use PDO;
use DB;
class CongViecModel extends Model
{


    //procedure SELECT_CONG_VIEC_DA
    public function SELECT_CONG_VIEC_DA($P_TIME_START, $P_TIME_END, $P_ID_ND, $P_ID_DA,$P_ID_DU_AN_KH, $P_ID_LOAI_CV, $P_TRANG_THAI_TD)
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT SELECT_CONG_VIEC_DA('$P_TIME_START', '$P_TIME_END', $P_ID_ND, $P_ID_DA, $P_ID_DU_AN_KH, $P_ID_LOAI_CV, $P_TRANG_THAI_TD) FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }

    public function SELECT_CONG_VIEC_PHANCONG($P_TIME_START, $P_TIME_END, $P_ID_ND, $P_ID_DA,$P_ID_DU_AN_KH, $P_ID_LOAI_CV, $P_NGUOI_NHAN_VIEC)
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT SELECT_CONG_VIEC_PHANCONG('$P_TIME_START', '$P_TIME_END', '$P_ID_ND', $P_ID_DA, $P_ID_DU_AN_KH, $P_ID_LOAI_CV, '$P_NGUOI_NHAN_VIEC') FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
    
    public function THEM_CAPNHAT_CONGVIEC($arr_params)
    {
            $sql = "DECLARE
            P_ID_CV_DA NUMBER;
            P_TEN_CV VARCHAR2(255);
            P_NOI_DUNG_CV VARCHAR2(4000);
            P_NGAY_TIEP_NHAN DATE;
            P_NGAY_GIAO_VIEC DATE;
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
            P_TIME_NHAN_VIEC VARCHAR2(100);
            P_TIME_HOAN_THANH VARCHAR2(100);
            P_HAN_HOAN_THANH DATE;
        BEGIN
        :RESULT_CV := THEM_CAPNHAT_CONGVIEC(:P_ID_CV_DA, :P_TEN_CV, :P_NOI_DUNG_CV, :P_NGAY_TIEP_NHAN, :P_NGAY_GIAO_VIEC,  :P_NGAY_HOAN_THANH, :P_NGAY_CAM_KET, :P_GIO_THUC_HIEN, :P_DO_UU_TIEN, 
        :P_MA_JIRA, :P_NGUOI_GIAO_VIEC, :P_NGUOI_NHAN_VIEC, :P_TIEN_DO, :P_GHI_CHU, :P_LY_DO, :P_THAM_DINH_TGIAN, :P_THAM_DINH_KHOI_LUONG, :P_THAM_DINH_CHAT_LUONG, :P_ID_LOAI_CV, 
        :P_TRANG_THAI, :P_ACTION, :P_TYPE, :P_NGUOI_YEU_CAU, :P_NGUOI_NHAP, :P_TIME_NHAN_VIEC, :P_TIME_HOAN_THANH, :P_HAN_HOAN_THANH);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_CV_DA',$arr_params["P_ID_CV_DA"], PDO::PARAM_INT);
        $stmt->bindParam(':P_TEN_CV',$arr_params["P_TEN_CV"]);
        $stmt->bindParam(':P_NOI_DUNG_CV',$arr_params["P_NOI_DUNG_CV"]);
        $stmt->bindParam(':P_NGAY_TIEP_NHAN',$arr_params["P_NGAY_TIEP_NHAN"]);
        $stmt->bindParam(':P_NGAY_GIAO_VIEC',$arr_params["P_NGAY_GIAO_VIEC"]);
        $stmt->bindParam(':P_NGAY_HOAN_THANH',$arr_params["P_NGAY_HOAN_THANH"]);
        $stmt->bindParam(':P_NGAY_CAM_KET',$arr_params["P_NGAY_HOAN_THANH"]);
        $stmt->bindParam(':P_GIO_THUC_HIEN',$arr_params["P_GIO_THUC_HIEN"]);
        $stmt->bindParam(':P_DO_UU_TIEN',$arr_params["P_DO_UU_TIEN"]);
        $stmt->bindParam(':P_MA_JIRA',$arr_params["P_MA_JIRA"]);
        $stmt->bindParam(':P_NGUOI_GIAO_VIEC',$arr_params["P_NGUOI_GIAO_VIEC"]);
        $stmt->bindParam(':P_NGUOI_NHAN_VIEC',$arr_params["P_NGUOI_NHAN_VIEC"]);
        $stmt->bindParam(':P_TIEN_DO',$arr_params["P_TIEN_DO"], PDO::PARAM_INT);
        $stmt->bindParam(':P_GHI_CHU',$arr_params["P_GHI_CHU"]);
        $stmt->bindParam(':P_LY_DO',$arr_params["P_LY_DO"]);
        $stmt->bindParam(':P_THAM_DINH_TGIAN',$arr_params["P_THAM_DINH_TGIAN"]);
        $stmt->bindParam(':P_THAM_DINH_KHOI_LUONG',$arr_params["P_THAM_DINH_KHOI_LUONG"]);
        $stmt->bindParam(':P_THAM_DINH_CHAT_LUONG',$arr_params["P_THAM_DINH_CHAT_LUONG"]);
        $stmt->bindParam(':P_ID_LOAI_CV',$arr_params["P_ID_LOAI_CV"]);
        $stmt->bindParam(':P_TRANG_THAI',$arr_params["P_TRANG_THAI"]);
        $stmt->bindParam(':P_ACTION',$arr_params["P_ACTION"]);
        $stmt->bindParam(':P_TYPE',$arr_params["P_TYPE"]);
        $stmt->bindParam(':P_NGUOI_YEU_CAU',$arr_params["P_NGUOI_YEU_CAU"]);
        $stmt->bindParam(':P_NGUOI_NHAP',$arr_params["P_NGUOI_NHAP"]);
        $stmt->bindParam(':P_TIME_NHAN_VIEC',$arr_params["P_TIME_NHAN_VIEC"]);
        $stmt->bindParam(':P_TIME_HOAN_THANH',$arr_params["P_TIME_HOAN_THANH"]);
        $stmt->bindParam(':P_HAN_HOAN_THANH',$arr_params["P_HAN_HOAN_THANH"]);
        $stmt->bindParam(':RESULT_CV',$result, PDO::PARAM_INT);
        $stmt->execute();
        return $result;
    }

    public function SELECT_CONGVIEC_TRONG_NGAY($P_ID_ND)
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT SELECT_CONGVIEC_TRONG_NGAY('$P_ID_ND') FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }



    public function GUI_THAM_DINH($arr_params)
    {
        $sql = "DECLARE
                    P_ARRAY_ID_CV_DA VARCHAR2(1000);
                    P_ACTION_TD NUMBER;
                BEGIN
                    :RESULT_CV := GUI_THAM_DINH(:P_ARRAY_ID_CV_DA, :P_ACTION_TD);
                END;
        ";
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ARRAY_ID_CV_DA',$arr_params["P_ARRAY_ID_CV_DA"]);
        $stmt->bindParam(':P_ACTION_TD',$arr_params["P_ACTION_TD"], PDO::PARAM_INT);
        $stmt->bindParam(':RESULT_CV',$RESULT_CV, PDO::PARAM_INT);
        $stmt->execute();
        return $RESULT_CV;
    }

    public function THAM_DINH_CONG_VIEC_DA($arr_params)
    {
        $sql = "DECLARE
            P_ID_CV_DA NUMBER;
            P_THAM_DINH_TGIAN NUMBER;
            P_THAM_DINH_CHAT_LUONG NUMBER;
            P_THAM_DINH_KHOI_LUONG NUMBER;
            P_NGUOI_THAM_DINH NUMBER;
        BEGIN
            :result :=THAM_DINH_CONG_VIEC_DA(:P_ID_CV_DA, :P_THAM_DINH_TGIAN, :P_THAM_DINH_CHAT_LUONG, :P_THAM_DINH_KHOI_LUONG, :P_NGUOI_THAM_DINH);
        END;";
       
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_CV_DA',$arr_params["P_ID_CV_DA"],PDO::PARAM_INT);
        $stmt->bindParam(':P_THAM_DINH_TGIAN',$arr_params["P_THAM_DINH_TGIAN"]);
        $stmt->bindParam(':P_THAM_DINH_CHAT_LUONG',$arr_params["P_THAM_DINH_CHAT_LUONG"],PDO::PARAM_INT);
        $stmt->bindParam(':P_THAM_DINH_KHOI_LUONG',$arr_params["P_THAM_DINH_KHOI_LUONG"],PDO::PARAM_INT);
        $stmt->bindParam(':P_NGUOI_THAM_DINH',$arr_params["P_NGUOI_THAM_DINH"],PDO::PARAM_INT);
        $stmt->bindParam(':result',$result);
        $stmt->execute();
        return $result;
    }

    public function CAPNHAT_SETTING($P_ID_SETTING, $P_ID_ND, $P_VALUE_SETTING)
    {
        $sql = "DECLARE
            P_ID_SETTING NUMBER;
            P_VALUE_SETTING VARCHAR2(2000);
            BEGIN
                :RESULT_CV := CAPNHAT_SETTING(:P_ID_SETTING, :P_ID_ND, :P_VALUE_SETTING);
            END;"; 
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_SETTING',$P_ID_SETTING, PDO::PARAM_INT);
        $stmt->bindParam(':P_ID_ND',$P_ID_ND, PDO::PARAM_INT);
        $stmt->bindParam(':P_VALUE_SETTING',$P_VALUE_SETTING);
        $stmt->bindParam(':RESULT_CV',$RESULT_CV, PDO::PARAM_INT);
        $stmt->execute();
        return $RESULT_CV;
    }

    public function SETTING_HIENTHI_MODAL_CV($P_ID_SETTING ,$P_ID_ND, $P_VALUE_SETTING)
    {
        $sql = "DECLARE
            P_ID_ND NUMBER;
            P_ID_SETTING NUMBER;
            P_VALUE_SETTING VARCHAR2(4000);
            BEGIN
                :RESULT_CV := CAPNHAT_SETTING(:P_ID_SETTING, :P_ID_ND, :P_VALUE_SETTING);
            END;"; 
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_SETTING',$P_ID_SETTING, PDO::PARAM_INT);
        $stmt->bindParam(':P_ID_ND',$P_ID_ND, PDO::PARAM_INT);
        $stmt->bindParam(':P_VALUE_SETTING',$P_VALUE_SETTING);
        $stmt->bindParam(':RESULT_CV',$RESULT_CV, PDO::PARAM_INT);
        $stmt->execute();
        return $RESULT_CV;
    }

    public function SELECT_CV_TH()
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT SELECT_CV_TH() FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }

}
