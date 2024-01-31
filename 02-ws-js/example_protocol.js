return (
  (B.Protocol =
    (((n = {}).AceAntiDataPush =
      ((W.create = function e(t) {
        return new W(t);
      }),
        (W.encode = function e(t, o) {
          return (o = o || $Writer.create()), t.AntiData && o.uint32(10).bytes(t.AntiData), o;
        }),
        (W.decode = function e(t, o) {
          t instanceof $Reader || (t = $Reader.create(t));
          for (var n = void 0 === o ? t.len : t.pos + o, r = new $root.Aki.Protocol.AceAntiDataPush(); t.pos < n;) {
            var i = t.uint32();
            i >>> 3 == 1 ? (r.AntiData = t.bytes()) : t.skipType(7 & i);
          }
          return r;
        }),
        W)),
      (n.AchievementProgress =
        ((j.create = function e(t) {
          return new j(t);
        }),
          (j.encode = function e(t, o) {
            return (o = o || $Writer.create()), t.CurProgress && o.uint32(8).int32(t.CurProgress), t.TotalProgress && o.uint32(16).int32(t.TotalProgress), o;
          }),
          (j.decode = function e(t, o) {
            t instanceof $Reader || (t = $Reader.create(t));
            for (var n = void 0 === o ? t.len : t.pos + o, r = new $root.Aki.Protocol.AchievementProgress(); t.pos < n;) {
              var i = t.uint32();
              switch (i >>> 3) {
                case 1:
                  r.CurProgress = t.int32();
                  break;
                case 2:
                  r.TotalProgress = t.int32();
                  break;
                case 27:
                  r.ActionGroupNodeAction = $root.Aki.Protocol.ActionGroupNodeActionCtxPb.decode(t, t.uint32());
                  break;
                default:
                  t.skipType(7 & i);
              }
            }
            return r;
          }),
          j)),
      (n.ActionFinishResponse =
        ((oe.create = function e(t) {
          return new oe(t);
        }),
          (oe.encode = function e(t, o) {
            return (o = o || $Writer.create()), t.Code && o.uint32(8).int32(t.Code), o;
          }),
          (oe.decode = function e(t, o) {
            t instanceof $Reader || (t = $Reader.create(t));
            for (var n = void 0 === o ? t.len : t.pos + o, r = new $root.Aki.Protocol.ActionFinishResponse(); t.pos < n;) {
              var i = t.uint32();
              i >>> 3 == 1 ? (r.EntityCtx = $root.Aki.Protocol.EntityCtxPb.decode(t, t.uint32())) : t.skipType(7 & i);
            }
            return r;
          }),
          oe)),
      (n.SlientFirstAwardState = ((t = {}), ((e = Object.create(t))[(t[0] = "NotUnlock")] = 0),
        (e[(t[1] = "NotFinish")] = 1),
        (e[(t[2] = "IsFinish")] = 2),
        (e[(t[3] = "IsReceive")] = 3), e)),
      n)),
  B
);
