<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use PDO;
use App\model\ThongKeModel;
class ThongKeController extends Controller
{
    public function so_luong_lcv_12_thang()
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT THONG_KE_LCV_12THANG() FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
        
    }
    public function thongke_du_an_kh()
    {
        $thong_ke = new ThongKeModel();
        $result = $thong_ke->THONGKE_DU_AN_KH();
        return $result;

    }
}
