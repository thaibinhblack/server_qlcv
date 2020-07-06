<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;
use PDO;
use DB;
class StudyModel extends Model
{
    public function THEM_MOI_QUESTION($array_form)
    {
        $sql = "DECLARE
                P_ID_STUDY NUMBER;
                P_NAME_QUESTION VARCHAR2(255);
                P_CONTENT_QUESTION VARCHAR2(4000);
                P_SQL_QUESTION VARCHAR2(4000);
            BEGIN
                :RESULT_CV := THEM_MOI_QUESTION(:P_ID_STUDY, :P_NAME_QUESTION, :P_CONTENT_QUESTION, :P_SQL_QUESTION);
            END;
        ";
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_STUDY',$array_form["P_ID_STUDY"], PDO::PARAM_INT);
        $stmt->bindParam(':P_NAME_QUESTION',$array_form["P_NAME_QUESTION"]);
        $stmt->bindParam(':P_CONTENT_QUESTION',$array_form["P_CONTENT_QUESTION"]);
        $stmt->bindParam(':P_SQL_QUESTION',$array_form["P_SQL_QUESTION"]);
        $stmt->bindParam(':RESULT_CV',$RESULT_CV, PDO::PARAM_INT);
        $stmt->execute();
        return $RESULT_CV;
    }
}
