  CREATE OR REPLACE EDITIONABLE FUNCTION "HIS_MANAGER"."NOT_KB_CAPGIUONGBN_SVV_NAMCUNG" (
  p_dvtt                         IN VARCHAR2,
  p_stt_logkhoaphong             IN VARCHAR2,
  p_stt_benhan                   IN VARCHAR2,
  p_stt_dotdieutri               IN VARCHAR2,
  p_mabenhnhan                   IN NUMBER,
  p_maphongban                   IN VARCHAR2,
  p_ngayvao                      IN TIMESTAMP,
  p_nhanvienlap                  IN NUMBER,
  p_maphongbenh                  IN VARCHAR2,
  p_magiuongbenh                 IN VARCHAR2,
  p_bhyt_thanhtoan               IN NUMBER,
  p_sovaovien                    IN NUMBER,
  p_sovaovien_dt                 IN NUMBER,
  p_namcungnguoi                 IN NUMBER,-- 1,0
  p_songuoinamcung               IN NUMBER,-- 1,2,3
  p_cg_sostt_giuongbenh          NUMBER DEFAULT 1,
  p_cg_loaigiuongke_giuongbenh   VARCHAR2 DEFAULT 'H',
  p_KCAPGIUONGKHIDATHANHTOANNT          NUMBER DEFAULT 0,
  p_KCAPGIUONGKHIDATHANHTOANBANT          NUMBER DEFAULT 0
) RETURN VARCHAR2 IS

  v_sotienbhkchi         NUMBER(
                         18,
                         4
                         );
  v_ngoaidanhmuc         NUMBER(1);
  v_sothebhyt            VARCHAR2(20);
  v_cobhyt               NUMBER(1);
  v_tt_dotdieutri        NUMBER(10);
  v_trang_thai           NUMBER(10); -- tr?ng thái b?nh án
  v_trang_thai_logkhoa   NUMBER(10); -- tr?ng thái b?nh án
  v_maxlog               NUMBER(10);
  v_giagiuongbenh        NUMBER(18);
  v_return_value         VARCHAR2(5);
  v_kiemtra_cg           NUMBER(11);
  v_kiemtra_tt  NUMBER(11);
  v_ktrbant number(3);
  v_thamso26001 number(1) default 0;
  v_thamso26002 number(1) default 0;
  v_kiemtracunggiuong number(10) default 0;
  --
  p_sql clob;
  p_thamso varchar2(3);
  v_thamso number(5);
  p_thamso82785 varchar2(2);
  p_ngaytao date := trunc(SYSDATE);
  p_thamso_ngay date;
  p_thamso_gia_bhyt varchar2(30);
  p_thamso_gia_kbhyt varchar2(30);
  v_capgiuong_hgi number(1) DEFAULT 0;
  BEGIN
    -- set transaction name 'not_kb_capgiuongbn_svv';
    v_thamso26001 := DM_TSDV_SL_MTSO(p_dvtt, '26001');
    v_thamso26002 := DM_TSDV_SL_MTSO(p_dvtt, '26002');
  v_capgiuong_hgi := get_tsdv(p_dvtt, 93217,0);
    if v_thamso26001 = 1 then
      if v_thamso26002 = 1 then
      begin
      if p_namcungnguoi = 0 then
          select count(a.so_giuong_tai_khoa_so) into v_kiemtracunggiuong
            from his_manager.noitru_loggiuongbenh a
            where   a.maphongban = p_maphongban
              and a.so_giuong_tai_khoa_so = p_cg_sostt_giuongbenh
              and a.trang_thai <3
              and (a.ngayra is null or a.songaydieutri is null or NGAYRA < p_ngayvao)
              and a.nam_cung_giuong = 0 ;
            else
              select count(a.so_giuong_tai_khoa_so) into v_kiemtracunggiuong
            from his_manager.noitru_loggiuongbenh a
            where   a.maphongban = p_maphongban
              and a.so_giuong_tai_khoa_so = p_cg_sostt_giuongbenh
              and a.trang_thai <3
              and (a.ngayra is null or a.songaydieutri is null or NGAYRA < p_ngayvao);
          end if;
      exception when no_data_found then v_kiemtracunggiuong :=0 ;
      end;
      else
      begin
       if p_namcungnguoi = 0 then
         select count(a.MAGIUONGBENH) into v_kiemtracunggiuong
          from his_manager.noitru_loggiuongbenh a
          where a.maphongban = p_maphongban
            and a.magiuongbenh = p_cg_sostt_giuongbenh--and a.magiuongbenh = p_magiuongbenh
            and a.trang_thai <3
            and (a.ngayra is null or a.songaydieutri is null or NGAYRA < p_ngayvao)
            and a.nam_cung_giuong = 0;
        else
            select count(a.MAGIUONGBENH) into v_kiemtracunggiuong
          from his_manager.noitru_loggiuongbenh a
          where a.maphongban = p_maphongban
            and a.magiuongbenh = p_cg_sostt_giuongbenh--and a.magiuongbenh = p_magiuongbenh
            and a.trang_thai <3
            and (a.ngayra is null or a.songaydieutri is null or NGAYRA < p_ngayvao);
        end if;
        exception when no_data_found then v_kiemtracunggiuong :=0;
      end;
      if (v_kiemtracunggiuong > 0 and p_namcungnguoi = 0) or (v_kiemtracunggiuong > p_songuoinamcung and p_namcungnguoi = 1)  then
        return '-5';
      end if;
      end if;
    end if;

    SELECT
      COUNT(1)
    INTO
      v_kiemtra_cg
    FROM
      noitru_loggiuongbenh
    WHERE
      dvtt = p_dvtt
      AND
      stt_benhan = p_stt_benhan
      AND
      stt_dotdieutri = p_stt_dotdieutri
      AND
      ngayra IS NULL;

    IF
    v_kiemtra_cg > 0
    THEN
      RETURN '-1';
    END IF;

    SELECT
      trang_thai,bant
    INTO
      v_trang_thai,v_ktrbant
    FROM
      noitru_benhan
    WHERE
      dvtt = p_dvtt
      AND
      stt_benhan = p_stt_benhan
      AND
      sovaovien = p_sovaovien;

  if (p_KCAPGIUONGKHIDATHANHTOANNT=1 and v_ktrbant=1) THEN

        select count(1) into v_kiemtra_tt from his_manager.vienphinoitru_lantt
        where sovaovien=p_sovaovien
        and sovaovien_dt=p_sovaovien_dt
        and dvtt=p_dvtt
        and stt_benhan=p_stt_benhan
        and stt_dotdieutri=p_stt_dotdieutri
        and tt_lantt=1;
        IF (v_kiemtra_tt>0) THEN
        RETURN '-10';
        END IF;
  elsif (p_KCAPGIUONGKHIDATHANHTOANBANT=1 and v_ktrbant=0) THEN

   select count(1) into v_kiemtra_tt from his_manager.vienphinoitru_lantt
        where sovaovien=p_sovaovien
        and sovaovien_dt=p_sovaovien_dt
        and dvtt=p_dvtt
        and stt_benhan=p_stt_benhan
        and stt_dotdieutri=p_stt_dotdieutri
        and tt_lantt=1;

        IF (v_kiemtra_tt>0) THEN
        RETURN '-10';
        END IF;

    end if;

    SELECT
      tt_dotdieutri,
      cobhyt,
      sobaohiemyte
    INTO
      v_tt_dotdieutri,v_cobhyt,v_sothebhyt
    FROM
      noitru_dotdieutri
    WHERE
      dvtt = p_dvtt
      AND
      stt_benhan = p_stt_benhan
      AND
      stt_dotdieutri = p_stt_dotdieutri
      AND
      sovaovien = p_sovaovien
      AND
      sovaovien_dt = p_sovaovien_dt;
    -- TGGDEV 42897
    begin
      select mota_thamso into p_thamso82785 from his_fw.dm_thamso_donvi where dvtt=p_dvtt and ma_thamso = 82785;
      exception when NO_DATA_FOUND THEN
      p_thamso82785 := '0';
    end;
    if p_thamso82785 = '1' then
      select trunc(ddt.ngayvao) into p_ngaytao
      from his_manager.noitru_dotdieutri ddt
      where dvtt = p_dvtt and sovaovien = p_sovaovien
            and sovaovien_dt = p_sovaovien_dt;
    end if;
    begin
      select mota_thamso into p_thamso
      from his_fw.dm_thamso_donvi where dvtt = p_dvtt and ma_thamso = 208;
      exception when NO_DATA_FOUND THEN
      p_thamso:= 0;
      v_thamso:= 0;
    end;

    if p_thamso != 0 then
      LOOP
        begin
          select g.ngay_ap_dung_truyen, g.ma_thamso_truyen_truoc
                 into p_thamso_ngay, v_thamso
          from his_manager.danhmuc_ngayapdung_dvtt g
          where g.ma_thamso_truyen= p_thamso and g.dvtt = p_dvtt;
          exception when no_data_found then
          p_thamso := 0;
          v_thamso := 0;
        end;
        if p_thamso != 0 then
          begin
            select g.column_gia_bhyt, g.column_gia_kbhyt
            into p_thamso_gia_bhyt,p_thamso_gia_kbhyt
            from his_manager.Danhmuc_Giathaydoi g
            where g.ma_thamso_truyen= p_thamso;
            exception when no_data_found then
            p_thamso := 0;
            v_thamso := 0;
          end;
        end if;
        if p_ngaytao < p_thamso_ngay then p_thamso := v_thamso; end if;
        EXIT WHEN p_ngaytao >= p_thamso_ngay or p_thamso = 0;
      END LOOP;
    end if;
    -- END TGGDEV-42897
    IF p_thamso = 0 THEN
      SELECT
        case when v_cobhyt = 0 then loai.gia_dich_vu else case loai.ngoai_danh_muc when 0 then  loai.gia_loai_giuong else loai.gia_dich_vu end end AS gia_loai_giuong,
        loai.ngoai_danh_muc,
        loai.tien_bh_khongchi
      INTO
        v_giagiuongbenh,v_ngoaidanhmuc,v_sotienbhkchi
      FROM
        dm_loaigiuongbenh loai,
        dm_giuongbenh giuong
      WHERE
        giuong.magiuongbenh = p_magiuongbenh
        AND
        giuong.dvtt = p_dvtt
        AND
        loai.dvtt = p_dvtt
        AND
        giuong.maloaigiuongbenh = loai.maloaigiuongbenh
        AND
        to_number(giuong.ma_phong_ban) = to_number(p_maphongban);
    ELSE
        p_sql := 'SELECT
          case when ' || v_cobhyt ||' = 0 then loai.' || p_thamso_gia_kbhyt || '
            else case loai.ngoai_danh_muc when 0 then loai.' || p_thamso_gia_bhyt || ' else loai.'|| p_thamso_gia_kbhyt ||' end end AS gia_loai_giuong,
          loai.ngoai_danh_muc,
          loai.tien_bh_khongchi
        FROM
          dm_loaigiuongbenh loai,
          dm_giuongbenh giuong
        WHERE giuong.magiuongbenh = :p_magiuongbenh
          AND giuong.dvtt = :p_dvtt
          AND loai.dvtt = :p_dvtt
          AND giuong.maloaigiuongbenh = loai.maloaigiuongbenh
          AND to_number(giuong.ma_phong_ban) = to_number(' || p_maphongban || ')';
        EXECUTE IMMEDIATE p_sql INTO v_giagiuongbenh, v_ngoaidanhmuc, v_sotienbhkchi USING p_magiuongbenh, p_dvtt, p_dvtt ;
    END IF;
    -- END TGGDEV

    SELECT
      trang_thai
    INTO
      v_trang_thai_logkhoa
    FROM
      noitru_logkhoaphong
    WHERE
      dvtt = p_dvtt
      AND
      stt_benhan = p_stt_benhan
      AND
      stt_dotdieutri = p_stt_dotdieutri
      AND
      stt_logkhoaphong = p_stt_logkhoaphong
      AND
      sovaovien = p_sovaovien
      AND
      sovaovien_dt = p_sovaovien_dt;

    IF
    v_tt_dotdieutri <= 2
    THEN
      UPDATE noitru_dotdieutri
      SET
        tt_dotdieutri = 1 --
      WHERE
        dvtt = p_dvtt
        AND
        stt_benhan = p_stt_benhan
        AND
        stt_dotdieutri = p_stt_dotdieutri
        AND
        sovaovien = p_sovaovien
        AND
        sovaovien_dt = p_sovaovien_dt;

    END IF;

    IF
    v_trang_thai < 2
    THEN
      UPDATE noitru_benhan
      SET
        trang_thai = 2 -- dang di?u tr?
      WHERE
        dvtt = p_dvtt
        AND
        stt_benhan = p_stt_benhan
        AND
        sovaovien = p_sovaovien;

    END IF;


    UPDATE noitru_logkhoaphong
    SET
      trang_thai = 1 -- c?p nh?t l?i di?u tr? có giu?ng
    WHERE
      dvtt = p_dvtt
      AND
      stt_benhan = p_stt_benhan
      AND
      stt_dotdieutri = p_stt_dotdieutri
      AND
      stt_logkhoaphong = p_stt_logkhoaphong
      AND
      sovaovien = p_sovaovien
      AND
      sovaovien_dt = p_sovaovien_dt
      AND
      trang_thai < 3;

    SELECT
      nvl(
          MAX(CAST(stt_loggiuongbenh AS NUMBER(18,0) ) ),
          0
      )
    INTO
      v_maxlog
    FROM
      noitru_loggiuongbenh
    WHERE
      dvtt = p_dvtt
      AND
      stt_logkhoaphong = p_stt_logkhoaphong
      AND
      stt_benhan = p_stt_benhan
      AND
      stt_dotdieutri = p_stt_dotdieutri
      AND
      sovaovien = p_sovaovien
      AND
      sovaovien_dt = p_sovaovien_dt;

    INSERT INTO noitru_loggiuongbenh (
      stt_loggiuongbenh,
      dvtt,
      stt_logkhoaphong,
      stt_benhan,
      stt_dotdieutri,
      mabenhnhan,
      maphongban,
      dongia,
      ngayvao,
      nhanvienlap,
      thoigianlap,
      trang_thai,
      maphongbenh,
      magiuongbenh,
      bhyt_thanhtoan,
      sovaovien,
      sovaovien_dt,
      nam_cung_giuong,
      so_nguoi_nam,
      ngoai_danh_muc,
      tien_bh_khongchi,
      so_giuong_tai_khoa_so,
      so_giuong_tai_khoa_chuoi,
      loai_giuong_tai_khoa
    ) VALUES (
      (v_maxlog + 1),
      p_dvtt,
      p_stt_logkhoaphong,
      p_stt_benhan,
      p_stt_dotdieutri,
      p_mabenhnhan,
      p_maphongban,
      v_giagiuongbenh,
      case when v_capgiuong_hgi = 1 then trunc(p_ngayvao) else p_ngayvao end,
      p_nhanvienlap,
      systimestamp,
      1,
      p_maphongbenh,
      p_magiuongbenh,
      CASE v_cobhyt
      WHEN 1                        THEN
        CASE
        WHEN length(v_sothebhyt) = 15   THEN DECODE(
            v_ngoaidanhmuc,
            1,
            0,
            1
        )
        ELSE 0
        END
      ELSE 0
      END,
      p_sovaovien,
      p_sovaovien_dt,
      p_namcungnguoi,
      p_songuoinamcung,
      CASE v_cobhyt
      WHEN 1                        THEN
        CASE
        WHEN length(v_sothebhyt) = 15   THEN v_ngoaidanhmuc
        ELSE 1
        END
      ELSE 1
      END,
      v_sotienbhkchi,
      p_cg_sostt_giuongbenh,
      his_manager.chuyen_so_sang_chuoi(
          p_cg_sostt_giuongbenh,
          3
      ),
      p_cg_loaigiuongke_giuongbenh
    );

    UPDATE noitru_loggiuongbenh
    SET
      trang_thai = 2
    WHERE
      dvtt = p_dvtt
      AND
      stt_benhan = p_stt_benhan
      AND
      stt_dotdieutri = p_stt_dotdieutri
      AND
      stt_logkhoaphong = p_stt_logkhoaphong
      AND
      stt_loggiuongbenh != (v_maxlog + 1)
      AND
      sovaovien = p_sovaovien
      AND
      sovaovien_dt = p_sovaovien_dt;

    SELECT
     (v_maxlog + 1)
    INTO
      v_return_value
    FROM
      dual;

    RETURN v_return_value;
  END;

