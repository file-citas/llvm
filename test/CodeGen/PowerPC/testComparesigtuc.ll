; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl

@glob = common local_unnamed_addr global i8 0, align 1

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_igtuc(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_igtuc:
; CHECK:    sub [[REG:r[0-9]+]], r4, r3
; CHECK-NEXT:    rldicl r3, [[REG]], 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ugt i8 %a, %b
  %conv2 = zext i1 %cmp to i32
  ret i32 %conv2
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_igtuc_sext(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_igtuc_sext:
; CHECK:    sub [[REG:r[0-9]+]], r4, r3
; CHECK-NEXT:    sradi r3, [[REG]], 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ugt i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_igtuc_z(i8 zeroext %a) {
; CHECK-LABEL: test_igtuc_z:
; CHECK:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    xori r3, r3, 1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i8 %a, 0
  %conv1 = zext i1 %cmp to i32
  ret i32 %conv1
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_igtuc_sext_z(i8 zeroext %a) {
; CHECK-LABEL: test_igtuc_sext_z:
; CHECK:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    xori r3, r3, 1
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i8 %a, 0
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind
define void @test_igtuc_store(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_igtuc_store:
; CHECK:         sub [[REG:r[0-9]+]], r4, r3
; CHECK:         rldicl {{r[0-9]+}}, [[REG]], 1, 63
entry:
  %cmp = icmp ugt i8 %a, %b
  %conv3 = zext i1 %cmp to i8
  store i8 %conv3, i8* @glob, align 1
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_igtuc_sext_store(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_igtuc_sext_store:
; CHECK:         sub [[REG:r[0-9]+]], r4, r3
; CHECK:         sradi {{r[0-9]+}}, [[REG]], 63
entry:
  %cmp = icmp ugt i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @glob, align 1
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_igtuc_z_store(i8 zeroext %a) {
; CHECK-LABEL: test_igtuc_z_store:
; CHECK:    cntlzw r3, r3
; CHECK:    srwi r3, r3, 5
; CHECK:    xori r3, r3, 1
; CHECK:    stb r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i8 %a, 0
  %conv2 = zext i1 %cmp to i8
  store i8 %conv2, i8* @glob, align 1
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_igtuc_sext_z_store(i8 zeroext %a) {
; CHECK-LABEL: test_igtuc_sext_z_store:
; CHECK:    cntlzw r3, r3
; CHECK:    srwi r3, r3, 5
; CHECK:    xori r3, r3, 1
; CHECK:    neg r3, r3
; CHECK:    stb r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i8 %a, 0
  %conv2 = sext i1 %cmp to i8
  store i8 %conv2, i8* @glob, align 1
  ret void
}
