CREATE OR REPLACE EDITIONABLE FUNCTION "HIS_MANAGER"."NHV_NGT_CNTTNHV_F" (
    p_ngaygionhapvien            IN timestamp,
    p_benhchinh_nhapvien         IN varchar2,
    p_icd_nhapvien               IN varchar2,
    p_tenbenhchinh_nhapvien      IN varchar2,
    p_tenbenhphu_nhapvien        IN varchar2,
    p_NHAPVIENVAOKHOA            IN varchar2,
    p_TENKHOA_NHAPVIENVAOKHOA    IN varchar2,                                               
    p_LYDO_TRANGTHAI_BN_NHAPVIEN IN varchar2,
    p_stt_benhan                 IN varchar2,
    p_stt_dotdieutri             IN varchar2,
    p_NOIGIOITHIEU               IN number,
    p_tennoigioithieu            IN varchar2,
    p_chandoan_nguyennhan        IN varchar2,
    p_dvtt                       IN varchar2,
    p_NHAPVIENVAOPHONG           IN varchar2,   --THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
    p_TENPHONG_NHAPVIENVAOPHONG  IN varchar2    --THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
    )
return number IS
    v_kt_taophieu number(11);
    v_mabenhnhan  number(11);
BEGIN
    if (p_TENPHONG_NHAPVIENVAOPHONG = 'null')  p_TENPHONG_NHAPVIENVAOPHONG := null;
    select count(stt_dieutri) into v_kt_taophieu
    from noitru_dieutri
    where dvtt = p_dvtt and stt_benhan = p_stt_benhan and stt_dotdieutri = p_stt_dotdieutri;

    select mabenhnhan into v_mabenhnhan
    from noitru_benhan
    where dvtt = p_dvtt and stt_benhan = p_stt_benhan;

    if (v_kt_taophieu = 0) then
    update noitru_benhan
        set NHAPVIENVAOKHOA         = p_NHAPVIENVAOKHOA,
            TENKHOA_NHAPVIENVAOKHOA = p_TENKHOA_NHAPVIENVAOKHOA,
            MA_PHONGKHAM_DT = p_NHAPVIENVAOPHONG, --THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
            TEN_PHONGKHAM_DT = p_TENPHONG_NHAPVIENVAOPHONG --THÊM PHÒNG ĐIỀU TRỊ BANT - VEN HGI
        where stt_benhan = p_stt_benhan
        and dvtt = p_dvtt;
    update noitru_logkhoaphong
        set maphongban        = p_NHAPVIENVAOKHOA,
            thoigianchuyenden = p_ngaygionhapvien
        where dvtt = p_dvtt
        and stt_benhan = p_stt_benhan
        and stt_dotdieutri = p_stt_dotdieutri;

    end if;
    update noitru_benhan
        set ngaynhapvien          = p_ngaygionhapvien,
            NGAY_NHAPVIEN         = trunc(p_ngaygionhapvien),
            benhchinh_nhapvien    = p_benhchinh_nhapvien,
            icd_nhapvien          = p_icd_nhapvien,
            tenbenhchinh_nhapvien = p_tenbenhchinh_nhapvien,
            tenbenhphu_nhapvien   = p_tenbenhphu_nhapvien,
            LYDO_TRANGTHAI_BN_NHAPVIEN = p_LYDO_TRANGTHAI_BN_NHAPVIEN,
            NOIGIOITHIEU               = p_NOIGIOITHIEU,
            TEN_NOIGIOITHIEU           = p_tennoigioithieu,
            CHANDOAN_NGUYENNHAN        = p_chandoan_nguyennhan
    where stt_benhan = p_stt_benhan
        and dvtt = p_dvtt;
    update KB_PHIEUNHAPVIENNOITRU
        set icd = p_icd_nhapvien, chan_doan_icd = p_tenbenhchinh_nhapvien,
            NGAY_VAO_VIEN = p_ngaygionhapvien --CMU: 10/09/2018
    where dvtt = p_dvtt
        and ma_benh_nhan = v_mabenhnhan;
    update noitru_dotdieutri
        set ngayvao = p_ngaygionhapvien, NGAY_VAO = trunc(p_ngaygionhapvien)
    where stt_dotdieutri = p_stt_dotdieutri
        and stt_benhan = p_stt_benhan
        and dvtt = p_dvtt;
    return v_kt_taophieu;
END;/**/