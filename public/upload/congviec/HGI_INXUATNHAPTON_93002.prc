CREATE OR REPLACE PROCEDURE HIS_REPORTS.HGI_INXUATNHAPTON_93002 (
    P_DVTT IN VARCHAR2,
    v_tungay IN VARCHAR2,
    v_denngay IN VARCHAR2,
    P_MAKHO IN VARCHAR2,
    P_MALOAIVATTU IN VARCHAR2,
    P_MANHOMVATTU IN NUMBER,
    P_MANUOCSX IN NUMBER,
    cur OUT SYS_REFCURSOR
) IS
P_TUNGAY DATE;
P_DENNGAY DATE;
P_KYHIEU number(1);
p_93267 VARCHAR2(256) :=his_manager.GET_TSDV(P_DVTT,93267,'0');
BEGIN

    P_TUNGAY := to_date(v_tungay,'yyyy-mm-dd');
    P_DENNGAY := to_date(v_denngay,'yyyy-mm-dd');
    select count(1) into P_KYHIEU from his_manager.dc_tb_khovattu where dvtt = 93002 and kyhieu LIKE 'KHODONGY';
    IF (P_MALOAIVATTU = '0' AND P_MANHOMVATTU = 0) THEN
        OPEN cur FOR
        SELECT  duoc.DVTT,duoc.MAVATTU,vt.TENVATTU,vt.HOATCHAT,
        decode(p_93267,'0',vt.HAMLUONG,vt.MA_NHOM_THAU_VT) as HAMLUONG,
        decode(p_93267,'0',vt.DVT,vt.QUYETDINH) as DVT,
        duoc.DONGIA,vt.CACHSUDUNG,vt.SOGPDK,nhom.TENNHOMVATTU,
            SUM(SLTD)                AS SLTON,
            SUM(SLTD)*duoc.DONGIA    AS STTON,
            SUM(SLNT) AS SLNHAPTAM,
            SUM(SLNT)*duoc.DONGIA AS STNHAPTAM,
            SUM(SLNNCC) AS SLNHACC,
            SUM(SLNNCC)*duoc.DONGIA AS STNHACC,
            SUM(SLXNG+SLXN) AS SLNGOAITRU,
            SUM(SLXNG+SLXN)*duoc.DONGIA  AS STNGOAITRU,
            SUM(SLXN)                AS SLNOITRU,
            SUM(SLXN)*duoc.DONGIA    AS STNOITRU,
            SUM(SLTT)               AS SLTT,
            SUM(SLTT)*duoc.DONGIA   AS STTT,
            SUM(SLXCK)               AS SLKP,
            SUM(SLXCK)*duoc.DONGIA   AS STKP,
            SUM(SLXTR)               AS SLCHUYENTRAM,
            SUM(SLXTR)*duoc.DONGIA   AS STCHUYENTRAM,
            SUM(SLXTNCC)             AS SLXUATTRANCC,
            SUM(SLXTNCC)*duoc.DONGIA AS STXUATTRANCC,
            SUM(SLXCD)               AS SLCHUYENCD,
            SUM(SLXCD)*duoc.DONGIA   AS STCHUYENCD,
            SUM(SLXK)                AS SLXUATKHAC,
            SUM(SLXK)*duoc.DONGIA    AS STXUATKHAC,
            SUM(SLXH+SLXCD)                AS SLXUATHUY,
            SUM(SLXH+SLXCD)*duoc.DONGIA    AS STXUATHUY,
            SUM(SLXNG+SLXN+SLXCK+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI+SLXTR) AS TONGXUAT,
            SUM(SLXNG+SLXN+SLXCK+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI+SLXTR)*duoc.DONGIA AS TONGTIENXUAT,
            SUM(SLHTBN)              AS SLHTBN,
            SUM(SLHTBN)*duoc.DONGIA  AS STHTBN,
            SUM(SLHTKP)              AS SLHTKHOAPHONG,
            SUM(SLHTKP)*duoc.DONGIA  AS STHTKHOAPHONG,
            SUM(SLHTTYT)             AS SLHTTRAM,
            SUM(SLHTTYT)*duoc.DONGIA AS STHTTRAM,
            SUM(SLNNCC+SLHTKP+SLHTBN+SLCDEN+SLNT) AS TONGTRA,
            SUM(SLNNCC+SLHTKP+SLHTBN+SLCDEN+SLNT)*duoc.DONGIA AS TONGTIENTRA,
            SUM(SLTD+SLNNCC+SLNT-SLXNG-SLXN-SLXCK-SLXTR-SLXTNCC-SLXCD-SLXK-SLXH+SLHTBN+SLHTKP+SLHTTYT+SLCDEN-SLCDI) AS SLTONCUOI,
            SUM(SLTD+SLNNCC+SLNT-SLXNG-SLXN-SLXCK-SLXTR-SLXTNCC-SLXCD-SLXK-SLXH+SLHTBN+SLHTKP+SLHTTYT+SLCDEN-SLCDI)* duoc.DONGIA AS STTONCUOI,
            SUM(SLCDEN)              AS SLCDEN,
            SUM(SLCDEN)*duoc.DONGIA  AS STCDEN,
            SUM(SLCDI)               AS SLCDI,
            SUM(SLCDI)*duoc.DONGIA   AS STCDI
        FROM (SELECT * FROM HIS_REPORTS.hgi_xuatnhapton_93002 WHERE
                    (NGAY BETWEEN P_TUNGAY  AND P_DENNGAY AND nghiepvu != 'tondaukythangmoi')
                    OR (NGAY = P_TUNGAY AND nghiepvu = 'tondaukythangmoi'))duoc,
                his_manager.dc_tb_vattu vt,
                his_manager.dc_tb_khovattu kvt,
                his_manager.dc_tb_nhomvattu nhom
        WHERE 
            vt.dvtt   = P_DVTT
            AND kvt.dvtt  = P_DVTT
            AND duoc.dvtt = P_DVTT
            AND nhom.dvtt = P_DVTT
            AND duoc.dvtt = vt.dvtt
            AND duoc.dvtt = kvt.dvtt
            AND kvt.dvtt  = vt.dvtt
            AND kvt.makhovattu = duoc.MAKHO
            AND P_MAKHO LIKE ('%BK' || duoc.MAKHO || 'EK%')
            AND duoc.mavattu = vt.mavattu
            AND vt.MaNhomVatTu = nhom.MaNhomVatTu
            AND (P_MANUOCSX = 0 or (P_MANUOCSX = 1 and vt.manuocsx = 1) -- THUOC NOI
            OR (P_MANUOCSX = 2 and vt.manuocsx != 1)) -- THUOC NGOAI */
        GROUP BY nhom.TENNHOMVATTU,duoc.MAVATTU,vt.TENVATTU,vt.HOATCHAT,
            decode(p_93267,'0',vt.HAMLUONG,vt.MA_NHOM_THAU_VT),
            decode(p_93267,'0',vt.DVT,vt.QUYETDINH),
            duoc.DONGIA,vt.CACHSUDUNG,vt.SOGPDK,duoc.DVTT
        HAVING SUM(SLTD+SLNNCC+SLXNG+SLXN+SLXNG+SLXN+SLXCK+SLXTR+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI+SLHTBN+SLHTKP+SLHTTYT+SLCDEN)> 0 
        ORDER BY nhom.TENNHOMVATTU,duoc.MAVATTU;
    ELSE IF (P_MALOAIVATTU != '0' AND P_MANHOMVATTU = 0) THEN
        OPEN cur FOR
        SELECT  duoc.DVTT,duoc.MAVATTU,vt.TENVATTU,vt.HOATCHAT,
            decode(p_93267,'0',vt.HAMLUONG,vt.MA_NHOM_THAU_VT) as HAMLUONG,
            decode(p_93267,'0',vt.DVT,vt.QUYETDINH) as DVT,
            duoc.DONGIA,duoc.CACHSUDUNG,vt.SOGPDK,nhom.TENNHOMVATTU,
            SUM(SLTD)                AS SLTON,
            SUM(SLTD)*duoc.DONGIA    AS STTON,
            SUM(SLNT) AS SLNHAPTAM,
            SUM(SLNT)*duoc.DONGIA AS STNHAPTAM,
            SUM(SLNNCC) AS SLNHACC,
            SUM(SLNNCC)*duoc.DONGIA AS STNHACC,
            CASE WHEN P_KYHIEU = 0 THEN SUM(SLXNG+SLXN) ELSE SUM(SLXNG) END AS SLNGOAITRU,
            CASE WHEN P_KYHIEU = 0 THEN SUM(SLXNG+SLXN)*duoc.DONGIA ELSE SUM(SLXNG)*duoc.DONGIA END AS STNGOAITRU,
            SUM(SLXN)                AS SLNOITRU,
            SUM(SLXN)*duoc.DONGIA    AS STNOITRU,
            SUM(SLTT)               AS SLTT,
            SUM(SLTT)*duoc.DONGIA   AS STTT,
            SUM(SLXCK)               AS SLKP,
            SUM(SLXCK)*duoc.DONGIA   AS STKP,
            SUM(SLXTR)               AS SLCHUYENTRAM,
            SUM(SLXTR)*duoc.DONGIA   AS STCHUYENTRAM,
            SUM(SLXTNCC)             AS SLXUATTRANCC,
            SUM(SLXTNCC)*duoc.DONGIA AS STXUATTRANCC,
            SUM(SLXCD)               AS SLCHUYENCD,
            SUM(SLXCD)*duoc.DONGIA   AS STCHUYENCD,
            SUM(SLXK)                AS SLXUATKHAC,
            SUM(SLXK)*duoc.DONGIA    AS STXUATKHAC,
            SUM(SLXH+SLXCD)                AS SLXUATHUY,
            SUM(SLXH+SLXCD)*duoc.DONGIA    AS STXUATHUY,
            SUM(SLXNG+SLXN+SLXCK+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI+SLXTR) AS TONGXUAT,
            SUM(SLXNG+SLXN+SLXCK+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI+SLXTR)*duoc.DONGIA AS TONGTIENXUAT,
            SUM(SLHTBN)              AS SLHTBN,
            SUM(SLHTBN)*duoc.DONGIA  AS STHTBN,
            SUM(SLHTKP)              AS SLHTKHOAPHONG,
            SUM(SLHTKP)*duoc.DONGIA  AS STHTKHOAPHONG,
            SUM(SLHTTYT)             AS SLHTTRAM,
            SUM(SLHTTYT)*duoc.DONGIA AS STHTTRAM,
            SUM(SLHTBN+SLHTKP+SLHTTYT)AS TONGTRA,
            SUM(SLHTBN+SLHTKP+SLHTTYT)*duoc.DONGIA AS TONGTIENTRA,
            SUM(SLTD+SLNNCC-SLXNG-SLXN-SLXCK-SLXTR-SLXTNCC-SLXCD-SLXK-SLXH+SLHTBN+SLHTKP+SLHTTYT+SLCDEN-SLCDI) AS SLTONCUOI,
            SUM(SLTD+SLNNCC-SLXNG-SLXN-SLXCK-SLXTR-SLXTNCC-SLXCD-SLXK-SLXH+SLHTBN+SLHTKP+SLHTTYT+SLCDEN-SLCDI)* duoc.DONGIA AS STTONCUOI,
            SUM(SLCDEN)              AS SLCDEN,
            SUM(SLCDEN)*duoc.DONGIA  AS STCDEN,
            SUM(SLCDI)               AS SLCDI,
            SUM(SLCDI)*duoc.DONGIA   AS STCDI
        FROM (SELECT * FROM HIS_REPORTS.hgi_xuatnhapton_93002 WHERE
                    (NGAY BETWEEN P_TUNGAY  AND P_DENNGAY AND nghiepvu != 'tondaukythangmoi')
                    OR (NGAY = P_TUNGAY AND nghiepvu = 'tondaukythangmoi'))duoc,
                his_manager.dc_tb_vattu vt,
                his_manager.dc_tb_khovattu kvt,
                his_manager.dc_tb_nhomvattu nhom
                -- his_manager.dc_tb_nuocsx nuocsx
        WHERE 
            vt.dvtt   = P_DVTT
            AND kvt.dvtt  = P_DVTT
            AND duoc.dvtt = P_DVTT
            AND nhom.dvtt = P_DVTT
            AND duoc.dvtt = vt.dvtt
            AND duoc.dvtt = kvt.dvtt
            AND kvt.dvtt  = vt.dvtt
            AND kvt.makhovattu = duoc.MAKHO
            AND P_MAKHO LIKE ('%BK' || duoc.MAKHO || 'EK%')
            AND duoc.mavattu = vt.mavattu
            AND vt.MaNhomVatTu = nhom.MaNhomVatTu
            --   AND vt.MaNuocSX = nuocsx.MaNuocSX
            AND nhom.maloaivattu LIKE ( CASE WHEN P_MALOAIVATTU = 'ALLTHUOC' THEN 'TH%' WHEN P_MALOAIVATTU = 'ALLVATTU' THEN 'VT_%' ELSE P_MALOAIVATTU END) 
            AND (P_MANUOCSX = 0 or (P_MANUOCSX = 1 and vt.manuocsx = 1) -- THUOC NOI
            OR (P_MANUOCSX = 2 and vt.manuocsx != 1)) -- THUOC NGOAI */
        GROUP BY duoc.DVTT,duoc.MAVATTU,duoc.TENVATTU,duoc.HOATCHAT,
            decode(p_93267,'0',vt.HAMLUONG,vt.MA_NHOM_THAU_VT),
            decode(p_93267,'0',vt.DVT,vt.QUYETDINH),
            duoc.DONGIA,duoc.CACHSUDUNG,vt.SOGPDK,nhom.TENNHOMVATTU
        HAVING SUM(SLTD+SLNNCC) > 0 OR SUM(SLXNG+SLXN) > 0 OR SUM(SLXNG+SLXN+SLXCK+SLXTR+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI) > 0 OR SUM(SLHTBN+SLHTKP+SLHTTYT+SLCDEN)> 0 
        ORDER BY nhom.TENNHOMVATTU,duoc.MAVATTU,duoc.TENVATTU,duoc.HOATCHAT,duoc.HAMLUONG,duoc.DVT,duoc.DONGIA,duoc.CACHSUDUNG,vt.SOGPDK,duoc.DVTT;
    ELSE
    OPEN cur FOR
        SELECT  duoc.DVTT,duoc.MAVATTU,duoc.TENVATTU,duoc.HOATCHAT,
        decode(p_93267,'0',vt.HAMLUONG,vt.MA_NHOM_THAU_VT) as HAMLUONG,
        decode(p_93267,'0',vt.DVT,vt.QUYETDINH) as DVT,
        duoc.DONGIA,duoc.CACHSUDUNG,vt.SOGPDK,nhom.TENNHOMVATTU,
        SUM(SLTD)                AS SLTON,
        SUM(SLTD)*duoc.DONGIA    AS STTON,
        SUM(SLNT) AS SLNHAPTAM,
        SUM(SLNT)*duoc.DONGIA AS STNHAPTAM,
        SUM(SLNNCC) AS SLNHACC,
        SUM(SLNNCC)*duoc.DONGIA AS STNHACC,
        CASE WHEN P_KYHIEU = 0 THEN SUM(SLXNG+SLXN) ELSE SUM(SLXNG) END AS SLNGOAITRU,
        CASE WHEN P_KYHIEU = 0 THEN SUM(SLXNG+SLXN)*duoc.DONGIA ELSE SUM(SLXNG)*duoc.DONGIA END AS STNGOAITRU,
        SUM(SLXN)                AS SLNOITRU,
        SUM(SLXN)*duoc.DONGIA    AS STNOITRU,
        SUM(SLTT)                AS SLTT,
        SUM(SLTT)*duoc.DONGIA    AS STTT,
        SUM(SLXCK)                AS SLKP,
        SUM(SLXCK)*duoc.DONGIA    AS STKP,
        SUM(SLXTR)               AS SLCHUYENTRAM,
        SUM(SLXTR)*duoc.DONGIA   AS STCHUYENTRAM,
        SUM(SLXTNCC)             AS SLXUATTRANCC,
        SUM(SLXTNCC)*duoc.DONGIA AS STXUATTRANCC,
        SUM(SLXCD)               AS SLCHUYENCD,
        SUM(SLXCD)*duoc.DONGIA   AS STCHUYENCD,
        SUM(SLXK)                AS SLXUATKHAC,
        SUM(SLXK)*duoc.DONGIA    AS STXUATKHAC,
        SUM(SLXH+SLXCD)                AS SLXUATHUY,
        SUM(SLXH+SLXCD)*duoc.DONGIA    AS STXUATHUY,
        SUM(SLXNG+SLXN+SLXCK+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI+SLXTR) AS TONGXUAT,
        SUM(SLXNG+SLXN+SLXCK+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI+SLXTR)*duoc.DONGIA AS TONGTIENXUAT,
        SUM(SLHTBN)              AS SLHTBN,
        SUM(SLHTBN)*duoc.DONGIA  AS STHTBN,
        SUM(SLHTKP)              AS SLHTKHOAPHONG,
        SUM(SLHTKP)*duoc.DONGIA  AS STHTKHOAPHONG,
        SUM(SLHTTYT)             AS SLHTTRAM,
        SUM(SLHTTYT)*duoc.DONGIA AS STHTTRAM,
        SUM(SLHTBN+SLHTKP+SLHTTYT)AS TONGTRA,
        SUM(SLHTBN+SLHTKP+SLHTTYT)*duoc.DONGIA AS TONGTIENTRA,
        SUM(SLTD+SLNNCC-SLXNG-SLXN-SLXCK-SLXTR-SLXTNCC-SLXCD-SLXK-SLXH+SLHTBN+SLHTKP+SLHTTYT+SLCDEN-SLCDI) AS SLTONCUOI,
        SUM(SLTD+SLNNCC-SLXNG-SLXN-SLXCK-SLXTR-SLXTNCC-SLXCD-SLXK-SLXH+SLHTBN+SLHTKP+SLHTTYT+SLCDEN-SLCDI)* duoc.DONGIA AS STTONCUOI,
        SUM(SLCDEN)              AS SLCDEN,
        SUM(SLCDEN)*duoc.DONGIA  AS STCDEN,
        SUM(SLCDI)               AS SLCDI,
        SUM(SLCDI)*duoc.DONGIA   AS STCDI
        FROM (SELECT * FROM HIS_REPORTS.hgi_xuatnhapton_93002 WHERE
                    (NGAY BETWEEN P_TUNGAY  AND P_DENNGAY AND nghiepvu != 'tondaukythangmoi')
                    OR (NGAY = P_TUNGAY AND nghiepvu = 'tondaukythangmoi'))duoc,
                his_manager.dc_tb_vattu vt,
                his_manager.dc_tb_khovattu kvt,
                his_manager.dc_tb_nhomvattu nhom
                --  his_manager.dc_tb_nuocsx nuocsx
        WHERE 
            vt.dvtt   = P_DVTT
            AND kvt.dvtt  = P_DVTT
            AND duoc.dvtt = P_DVTT
            AND nhom.dvtt = P_DVTT
            AND duoc.dvtt = vt.dvtt
            AND duoc.dvtt = kvt.dvtt
            AND kvt.dvtt  = vt.dvtt
            AND kvt.makhovattu = duoc.MAKHO
            AND P_MAKHO LIKE ('%BK' || duoc.MAKHO || 'EK%')
            AND duoc.mavattu = vt.mavattu
            AND vt.MaNhomVatTu = nhom.MaNhomVatTu
            -- AND vt.MaNuocSX = nuocsx.MaNuocSX
            AND nhom.maloaivattu = P_MALOAIVATTU
            AND vt.MaNhomVatTu = P_MANHOMVATTU
            AND (P_MANUOCSX = 0 or (P_MANUOCSX = 1 and vt.manuocsx = 1) -- THUOC NOI
            OR (P_MANUOCSX = 2 and vt.manuocsx != 1)) -- THUOC NGOAI */
        GROUP BY duoc.DVTT,duoc.MAVATTU,duoc.TENVATTU,duoc.HOATCHAT,
            decode(p_93267,'0',vt.HAMLUONG,vt.MA_NHOM_THAU_VT),
            decode(p_93267,'0',vt.DVT,vt.QUYETDINH),
            duoc.DONGIA,duoc.CACHSUDUNG,vt.SOGPDK,nhom.TENNHOMVATTU
        HAVING SUM(SLTD+SLNNCC) > 0 OR SUM(SLXNG+SLXN) > 0 OR SUM(SLXNG+SLXN+SLXCK+SLXTR+SLXTNCC+SLXCD+SLXK+SLXH+SLCDI) > 0 OR SUM(SLHTBN+SLHTKP+SLHTTYT+SLCDEN)> 0 
        ORDER BY nhom.TENNHOMVATTU,duoc.MAVATTU,duoc.TENVATTU,duoc.HOATCHAT,duoc.HAMLUONG,duoc.DVT,duoc.DONGIA,duoc.CACHSUDUNG,vt.SOGPDK,duoc.DVTT;
    END IF;
    END IF;
END HGI_INXUATNHAPTON_93002;
/
