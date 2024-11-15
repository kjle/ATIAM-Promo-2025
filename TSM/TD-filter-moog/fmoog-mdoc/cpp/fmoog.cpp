/* ------------------------------------------------------------
name: "fmoog"
Code generated with Faust 2.75.16 (https://faust.grame.fr)
Compilation options: -lang cpp -ct 1 -es 1 -mcd 16 -mdd 1024 -mdy 33 -single -ftz 0
------------------------------------------------------------ */

#ifndef  __mydsp_H__
#define  __mydsp_H__

#ifndef FAUSTFLOAT
#define FAUSTFLOAT float
#endif 

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <math.h>

#ifndef FAUSTCLASS 
#define FAUSTCLASS mydsp
#endif

#ifdef __APPLE__ 
#define exp10f __exp10f
#define exp10 __exp10
#endif

#if defined(_WIN32)
#define RESTRICT __restrict
#else
#define RESTRICT __restrict__
#endif

static float mydsp_faustpower2_f(float value) {
	return value * value;
}
static float mydsp_faustpower3_f(float value) {
	return value * value * value;
}

class mydsp : public dsp {
	
 private:
	
	int iVec0[2];
	FAUSTFLOAT fVslider0;
	FAUSTFLOAT fVslider1;
	int fSampleRate;
	float fConst0;
	float fConst1;
	float fRec5[2];
	float fVec1[2];
	float fConst2;
	int IOTA0;
	float fVec2[4096];
	float fConst3;
	float fRec6[2];
	float fVec3[2];
	float fVec4[4096];
	FAUSTFLOAT fVslider2;
	FAUSTFLOAT fVslider3;
	float fConst4;
	float fConst5;
	float fRec4[2];
	float fRec3[2];
	float fRec2[2];
	float fRec1[2];
	float fRec9[2];
	float fRec8[2];
	float fRec7[2];
	float fRec0[2];
	FAUSTFLOAT fCheckbox0;
	
 public:
	mydsp() {
	}
	
	void metadata(Meta* m) { 
		m->declare("compile_options", "-lang cpp -ct 1 -es 1 -mcd 16 -mdd 1024 -mdy 33 -single -ftz 0");
		m->declare("filename", "fmoog.dsp");
		m->declare("maths.lib/author", "GRAME");
		m->declare("maths.lib/copyright", "GRAME");
		m->declare("maths.lib/license", "LGPL with exception");
		m->declare("maths.lib/name", "Faust Math Library");
		m->declare("maths.lib/version", "2.8.0");
		m->declare("name", "fmoog");
		m->declare("oscillators.lib/lf_sawpos:author", "Bart Brouns, revised by Stéphane Letz");
		m->declare("oscillators.lib/lf_sawpos:licence", "STK-4.3");
		m->declare("oscillators.lib/name", "Faust Oscillator Library");
		m->declare("oscillators.lib/sawN:author", "Julius O. Smith III");
		m->declare("oscillators.lib/sawN:license", "STK-4.3");
		m->declare("oscillators.lib/version", "1.5.1");
		m->declare("platform.lib/name", "Generic Platform Library");
		m->declare("platform.lib/version", "1.3.0");
	}

	virtual int getNumInputs() {
		return 0;
	}
	virtual int getNumOutputs() {
		return 1;
	}
	
	static void classInit(int sample_rate) {
	}
	
	virtual void instanceConstants(int sample_rate) {
		fSampleRate = sample_rate;
		fConst0 = std::min<float>(1.92e+05f, std::max<float>(1.0f, float(fSampleRate)));
		fConst1 = 1.0f / fConst0;
		fConst2 = 0.25f * fConst0;
		fConst3 = 0.5f * fConst0;
		fConst4 = 3.1415927f / fConst0;
		fConst5 = 6.2831855f / fConst0;
	}
	
	virtual void instanceResetUserInterface() {
		fVslider0 = FAUSTFLOAT(0.1f);
		fVslider1 = FAUSTFLOAT(3.3e+02f);
		fVslider2 = FAUSTFLOAT(1.0f);
		fVslider3 = FAUSTFLOAT(1e+03f);
		fCheckbox0 = FAUSTFLOAT(0.0f);
	}
	
	virtual void instanceClear() {
		for (int l0 = 0; l0 < 2; l0 = l0 + 1) {
			iVec0[l0] = 0;
		}
		for (int l1 = 0; l1 < 2; l1 = l1 + 1) {
			fRec5[l1] = 0.0f;
		}
		for (int l2 = 0; l2 < 2; l2 = l2 + 1) {
			fVec1[l2] = 0.0f;
		}
		IOTA0 = 0;
		for (int l3 = 0; l3 < 4096; l3 = l3 + 1) {
			fVec2[l3] = 0.0f;
		}
		for (int l4 = 0; l4 < 2; l4 = l4 + 1) {
			fRec6[l4] = 0.0f;
		}
		for (int l5 = 0; l5 < 2; l5 = l5 + 1) {
			fVec3[l5] = 0.0f;
		}
		for (int l6 = 0; l6 < 4096; l6 = l6 + 1) {
			fVec4[l6] = 0.0f;
		}
		for (int l7 = 0; l7 < 2; l7 = l7 + 1) {
			fRec4[l7] = 0.0f;
		}
		for (int l8 = 0; l8 < 2; l8 = l8 + 1) {
			fRec3[l8] = 0.0f;
		}
		for (int l9 = 0; l9 < 2; l9 = l9 + 1) {
			fRec2[l9] = 0.0f;
		}
		for (int l10 = 0; l10 < 2; l10 = l10 + 1) {
			fRec1[l10] = 0.0f;
		}
		for (int l11 = 0; l11 < 2; l11 = l11 + 1) {
			fRec9[l11] = 0.0f;
		}
		for (int l12 = 0; l12 < 2; l12 = l12 + 1) {
			fRec8[l12] = 0.0f;
		}
		for (int l13 = 0; l13 < 2; l13 = l13 + 1) {
			fRec7[l13] = 0.0f;
		}
		for (int l14 = 0; l14 < 2; l14 = l14 + 1) {
			fRec0[l14] = 0.0f;
		}
	}
	
	virtual void init(int sample_rate) {
		classInit(sample_rate);
		instanceInit(sample_rate);
	}
	
	virtual void instanceInit(int sample_rate) {
		instanceConstants(sample_rate);
		instanceResetUserInterface();
		instanceClear();
	}
	
	virtual mydsp* clone() {
		return new mydsp();
	}
	
	virtual int getSampleRate() {
		return fSampleRate;
	}
	
	virtual void buildUserInterface(UI* ui_interface) {
		ui_interface->openVerticalBox("fmoog");
		ui_interface->addCheckButton("NL", &fCheckbox0);
		ui_interface->declare(&fVslider0, "style", "knob");
		ui_interface->declare(&fVslider0, "unit", "Hz");
		ui_interface->addVerticalSlider("delta", &fVslider0, FAUSTFLOAT(0.1f), FAUSTFLOAT(0.05f), FAUSTFLOAT(2.0f), FAUSTFLOAT(0.05f));
		ui_interface->declare(&fVslider2, "style", "knob");
		ui_interface->addVerticalSlider("drive", &fVslider2, FAUSTFLOAT(1.0f), FAUSTFLOAT(0.1f), FAUSTFLOAT(2e+01f), FAUSTFLOAT(0.1f));
		ui_interface->declare(&fVslider3, "scale", "log");
		ui_interface->declare(&fVslider3, "style", "knob");
		ui_interface->declare(&fVslider3, "unit", "Hz");
		ui_interface->addVerticalSlider("fc", &fVslider3, FAUSTFLOAT(1e+03f), FAUSTFLOAT(2e+01f), FAUSTFLOAT(5e+03f), FAUSTFLOAT(1.0f));
		ui_interface->declare(&fVslider1, "scale", "log");
		ui_interface->declare(&fVslider1, "style", "knob");
		ui_interface->declare(&fVslider1, "unit", "Hz");
		ui_interface->addVerticalSlider("freq", &fVslider1, FAUSTFLOAT(3.3e+02f), FAUSTFLOAT(2e+01f), FAUSTFLOAT(5e+03f), FAUSTFLOAT(1.0f));
		ui_interface->closeBox();
	}
	
	virtual void compute(int count, FAUSTFLOAT** RESTRICT inputs, FAUSTFLOAT** RESTRICT outputs) {
		FAUSTFLOAT* output0 = outputs[0];
		float fSlow0 = float(fVslider1);
		float fSlow1 = std::max<float>(fSlow0 + float(fVslider0), 23.44895f);
		float fSlow2 = std::max<float>(2e+01f, std::fabs(fSlow1));
		float fSlow3 = fConst1 * fSlow2;
		float fSlow4 = fConst2 / fSlow2;
		float fSlow5 = std::max<float>(0.0f, std::min<float>(2047.0f, fConst3 / fSlow1));
		int iSlow6 = int(fSlow5);
		float fSlow7 = std::floor(fSlow5);
		float fSlow8 = fSlow7 + (1.0f - fSlow5);
		float fSlow9 = std::max<float>(fSlow0, 23.44895f);
		float fSlow10 = std::max<float>(2e+01f, std::fabs(fSlow9));
		float fSlow11 = fConst1 * fSlow10;
		float fSlow12 = fConst2 / fSlow10;
		float fSlow13 = std::max<float>(0.0f, std::min<float>(2047.0f, fConst3 / fSlow9));
		int iSlow14 = int(fSlow13);
		int iSlow15 = iSlow14 + 1;
		float fSlow16 = std::floor(fSlow13);
		float fSlow17 = fSlow13 - fSlow16;
		float fSlow18 = fSlow16 + (1.0f - fSlow13);
		int iSlow19 = iSlow6 + 1;
		float fSlow20 = fSlow5 - fSlow7;
		float fSlow21 = 1.0f / fSlow2;
		float fSlow22 = 1.0f / fSlow10;
		float fSlow23 = float(fVslider2);
		float fSlow24 = float(fVslider3);
		float fSlow25 = fConst4 * fSlow24 * fSlow23;
		float fSlow26 = fConst5 * fSlow24;
		float fSlow27 = 1.0f / (fSlow26 + 1.0f);
		float fSlow28 = 0.5f * fSlow23;
		float fSlow29 = 0.33333334f * float(fCheckbox0);
		float fSlow30 = 1.0f / fSlow23;
		for (int i0 = 0; i0 < count; i0 = i0 + 1) {
			iVec0[0] = 1;
			int iTemp0 = 1 - iVec0[1];
			float fTemp1 = ((iTemp0) ? 0.0f : fSlow3 + fRec5[1]);
			fRec5[0] = fTemp1 - std::floor(fTemp1);
			float fTemp2 = mydsp_faustpower2_f(2.0f * fRec5[0] + -1.0f);
			fVec1[0] = fTemp2;
			float fTemp3 = fTemp2 - fVec1[1];
			float fTemp4 = float(iVec0[1]);
			float fTemp5 = fSlow4 * fTemp4 * fTemp3;
			fVec2[IOTA0 & 4095] = fTemp5;
			float fTemp6 = ((iTemp0) ? 0.0f : fSlow11 + fRec6[1]);
			fRec6[0] = fTemp6 - std::floor(fTemp6);
			float fTemp7 = mydsp_faustpower2_f(2.0f * fRec6[0] + -1.0f);
			fVec3[0] = fTemp7;
			float fTemp8 = fTemp7 - fVec3[1];
			float fTemp9 = fSlow12 * fTemp4 * fTemp8;
			fVec4[IOTA0 & 4095] = fTemp9;
			float fTemp10 = fConst2 * fTemp4 * (fSlow22 * fTemp8 + fSlow21 * fTemp3) - (fSlow20 * fVec2[(IOTA0 - iSlow19) & 4095] + fSlow18 * fVec4[(IOTA0 - iSlow14) & 4095] + fSlow17 * fVec4[(IOTA0 - iSlow15) & 4095] + fSlow8 * fVec2[(IOTA0 - iSlow6) & 4095]);
			fRec4[0] = fSlow27 * (fRec4[1] + fSlow25 * fTemp10);
			fRec3[0] = fSlow27 * (fRec3[1] + fSlow26 * fRec4[0]);
			fRec2[0] = fSlow27 * (fRec2[1] + fSlow26 * fRec3[0]);
			fRec1[0] = fSlow27 * (fRec1[1] + fSlow26 * fRec2[0]);
			float fTemp11 = mydsp_faustpower3_f(fRec2[0]);
			float fTemp12 = mydsp_faustpower3_f(fRec3[0]);
			float fTemp13 = mydsp_faustpower3_f(fRec4[0]);
			fRec9[0] = fSlow27 * (fRec9[1] + fSlow26 * (mydsp_faustpower3_f(fSlow28 * fTemp10) - fTemp13));
			fRec8[0] = fSlow27 * (fRec8[1] + fSlow26 * (fRec9[0] + fTemp13 - fTemp12));
			fRec7[0] = fSlow27 * (fRec7[1] + fSlow26 * (fRec8[0] + fTemp12 - fTemp11));
			fRec0[0] = fSlow27 * (fRec0[1] + fSlow26 * (fRec7[0] + fTemp11 - mydsp_faustpower3_f(fRec1[0])));
			output0[i0] = FAUSTFLOAT(fSlow30 * (fRec1[0] - fSlow29 * fRec0[0]));
			iVec0[1] = iVec0[0];
			fRec5[1] = fRec5[0];
			fVec1[1] = fVec1[0];
			IOTA0 = IOTA0 + 1;
			fRec6[1] = fRec6[0];
			fVec3[1] = fVec3[0];
			fRec4[1] = fRec4[0];
			fRec3[1] = fRec3[0];
			fRec2[1] = fRec2[0];
			fRec1[1] = fRec1[0];
			fRec9[1] = fRec9[0];
			fRec8[1] = fRec8[0];
			fRec7[1] = fRec7[0];
			fRec0[1] = fRec0[0];
		}
	}

};

#endif
