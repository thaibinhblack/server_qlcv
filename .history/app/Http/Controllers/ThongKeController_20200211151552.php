<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ThongKeController extends Controller
{
    public function so_luong_lcv_12_thang()
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT THONG_KE_LCV_12THANG() FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
        
    }
}
