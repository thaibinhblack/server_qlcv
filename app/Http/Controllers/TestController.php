<?php

namespace App\Http\Controllers;
use DB;
use PDO;
use ODB;
use DateTime;
use Illuminate\Http\Request;

class TestController extends Controller
{
    public function CONGVIEC_ID($id)
    {
        $RESULT = DB::SELECT("SELECT * FROM TB_CONG_VIEC_DA where ID_CV_DA = $id");
        $time_nhan_viec = json_decode($RESULT[0]->time_nhan_viec,true);
        $hh = $time_nhan_viec["HH"];
        $mm = $time_nhan_viec["mm"];
        $date = substr($RESULT[0]->ngay_tiep_nhan,0,10);
        $tgian_nhan_viec = $date.' '.$hh.':'.$mm;
        // $time =  new DateTime($tgian_nhan_viec);
        // $time_nhan_viec = $time->format('Y-m-d h:i:s');
        $time_hoan_thanh= json_decode($RESULT[0]->time_hoan_thanh,true);
        $hh_ht = $time_hoan_thanh["HH"];
        $mm_ht = $time_hoan_thanh["mm"];
        $date_ht = substr($RESULT[0]->ngay_hoan_thanh,0,10);
        $tgain_hoan_thanh = $date_ht.' '.$hh_ht.':'.$mm_ht;
        // $time_ht =  new DateTime($tgian_nhan_viec);
        // $tgain_hoan_thanh = $time_ht->format('Y-m-d h:i:s');

        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("UPDATE TB_CONG_VIEC_DA SET TGIAN_NHAN_VIEC = to_date('$tgian_nhan_viec', 'YYYY-MM-DD HH24:MI:SS') ,
            TGIAN_HOAN_THANH =   to_date('$tgain_hoan_thanh', 'YYYY-MM-DD HH24:MI:SS')  WHERE ID_CV_DA = $id");
        $result = $stmt->execute();

        return response()->json($result);       
        
    }

    public function CONGVIEC_ID_UPDATE(Request $request,$id)
    {
        $tgian_nhan_viec = $request->all();
        // $RESULT = DB::SELECT("UPDATE TB_CONG_VIEC_DA SET TGIAN_NHAN_VIEC = $tgian_nhan_viec WHERE ID_CV_DA = $id");
        return response()->json($tgian_nhan_viec["time"]);
    }
}
