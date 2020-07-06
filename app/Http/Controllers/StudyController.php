<?php

namespace App\Http\Controllers;

use DB;
use PDO;
use ODB;
use Illuminate\Http\Request;
use App\model\StudyModel;
 
class StudyController extends Controller
{

    public function season(Request $request)
    {
        $result = DB::SELECT("SELECT * FROM TB_STUDY");
        return response()->json($result);
    }

    public function store(Request $request)
    {   
        // return response()->json($request->all());
        $study = new StudyModel();
        $result = $study->THEM_MOI_QUESTION([
            "P_ID_STUDY" => $request->get("P_ID_STUDY"),
            "P_NAME_QUESTION" => $request->get("P_NAME_QUESTION"),
            "P_CONTENT_QUESTION" => $request->get("P_CONTENT_QUESTION"),
            "P_SQL_QUESTION" => $request->get("P_SQL_QUESTION")
        ]);

        return response()->json([
            "success" => true,
            "message" => "Thêm mới bài tập thành công",
            "result" => $result,
            "status" => 200
        ]);
    }
}
