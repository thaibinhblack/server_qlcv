  CREATE OR REPLACE EDITIONABLE FUNCTION "HIS_MANAGER"."CHUYEN_THAPPHAN_SANG_PHANSO" (p_thapphan varchar2) RETURN varchar2 IS
 nguyen varchar2(50);
 le varchar2(50);
 rs varchar2(50);
 tu number(10);
 mau number(10);
 ucln number(10);
 tam varchar2(50);
 thapphan varchar2(50);
 v_thapphan number(18,4) := replace(p_thapphan,',','.') ;
 --v_thapphan number(18,4) := cast(p_thapphan as  number(18,4));
BEGIN

  IF (v_thapphan = 0) then
    return '';
  end if;
  thapphan:= case when v_thapphan < 1 and v_thapphan > 0 then '0' || cast(v_thapphan as VARCHAR2)  else cast(v_thapphan as VARCHAR2)   end;


  nguyen:=SUBSTRING_INDEX(thapphan, '.', 1);

  if nguyen = v_thapphan then
    return nguyen;
  end if;

  le:='0.' || SUBSTRING_INDEX(thapphan, '.', -1);
  tu:=cast(le as number) *100; 
  mau:=100;

  if(tu=0) then
    return nguyen;
  end if;
  -- select tu;
  if(tu>=60 and tu<=70)
  then
    rs:='2/3';
  else
    if(tu>=30 and tu<=40) then
      rs:='1/3';      
    else
      if (tu>=16 and tu<=17) then
        rs:='1/6';
        else
      ucln:=tim_ucln(tu,mau);
      tu:=tu/ucln;
      mau:=mau/ucln;
      rs:=case when mau = 1 then cast(tu as VARCHAR2) else cast(tu as VARCHAR2) || '/' || cast(mau as VARCHAR2) end;
      -- rs:= 1;
    end if;
    end if;
  end if;
  tam:=case when rs!='0' then '+' || rs else '' end;
  rs:=case when nguyen !='0' then nguyen || tam else rs end;
  return rs;
END;


