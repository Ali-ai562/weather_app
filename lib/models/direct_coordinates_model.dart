class DirectCoordinatesModel {
  String? name;
  LocalNames? localNames;
  double? lat;
  double? lon;
  String? country;
  String? state;

  DirectCoordinatesModel(
      {this.name,
      this.localNames,
      this.lat,
      this.lon,
      this.country,
      this.state});

  DirectCoordinatesModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    localNames = json['local_names'] != null
        ? LocalNames.fromJson(json['local_names'])
        : null;
    lat = json['lat'];
    lon = json['lon'];
    country = json['country'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (localNames != null) {
      data['local_names'] = localNames!.toJson();
    }
    data['lat'] = lat;
    data['lon'] = lon;
    data['country'] = country;
    data['state'] = state;
    return data;
  }
}

class LocalNames {
  String? hi;
  String? de;
  String? es;
  String? ar;
  String? ja;
  String? et;
  String? pl;
  String? pa;
  String? kn;
  String? eo;
  String? ko;
  String? he;
  String? sw;
  String? ta;
  String? nn;
  String? ks;
  String? en;
  String? hy;
  String? oc;
  String? fr;
  String? ps;
  String? cs;
  String? tr;
  String? nl;
  String? fa;
  String? ml;
  String? sr;
  String? af;
  String? zh;
  String? pt;
  String? uk;
  String? no;
  String? it;
  String? sv;
  String? ru;
  String? el;
  String? ur;

  LocalNames(
      {this.hi,
      this.de,
      this.es,
      this.ar,
      this.ja,
      this.et,
      this.pl,
      this.pa,
      this.kn,
      this.eo,
      this.ko,
      this.he,
      this.sw,
      this.ta,
      this.nn,
      this.ks,
      this.en,
      this.hy,
      this.oc,
      this.fr,
      this.ps,
      this.cs,
      this.tr,
      this.nl,
      this.fa,
      this.ml,
      this.sr,
      this.af,
      this.zh,
      this.pt,
      this.uk,
      this.no,
      this.it,
      this.sv,
      this.ru,
      this.el,
      this.ur});

  LocalNames.fromJson(Map<String, dynamic> json) {
    hi = json['hi'];
    de = json['de'];
    es = json['es'];
    ar = json['ar'];
    ja = json['ja'];
    et = json['et'];
    pl = json['pl'];
    pa = json['pa'];
    kn = json['kn'];
    eo = json['eo'];
    ko = json['ko'];
    he = json['he'];
    sw = json['sw'];
    ta = json['ta'];
    nn = json['nn'];
    ks = json['ks'];
    en = json['en'];
    hy = json['hy'];
    oc = json['oc'];
    fr = json['fr'];
    ps = json['ps'];
    cs = json['cs'];
    tr = json['tr'];
    nl = json['nl'];
    fa = json['fa'];
    ml = json['ml'];
    sr = json['sr'];
    af = json['af'];
    zh = json['zh'];
    pt = json['pt'];
    uk = json['uk'];
    no = json['no'];
    it = json['it'];
    sv = json['sv'];
    ru = json['ru'];
    el = json['el'];
    ur = json['ur'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hi'] = hi;
    data['de'] = de;
    data['es'] = es;
    data['ar'] = ar;
    data['ja'] = ja;
    data['et'] = et;
    data['pl'] = pl;
    data['pa'] = pa;
    data['kn'] = kn;
    data['eo'] = eo;
    data['ko'] = ko;
    data['he'] = he;
    data['sw'] = sw;
    data['ta'] = ta;
    data['nn'] = nn;
    data['ks'] = ks;
    data['en'] = en;
    data['hy'] = hy;
    data['oc'] = oc;
    data['fr'] = fr;
    data['ps'] = ps;
    data['cs'] = cs;
    data['tr'] = tr;
    data['nl'] = nl;
    data['fa'] = fa;
    data['ml'] = ml;
    data['sr'] = sr;
    data['af'] = af;
    data['zh'] = zh;
    data['pt'] = pt;
    data['uk'] = uk;
    data['no'] = no;
    data['it'] = it;
    data['sv'] = sv;
    data['ru'] = ru;
    data['el'] = el;
    data['ur'] = ur;
    return data;
  }
}
