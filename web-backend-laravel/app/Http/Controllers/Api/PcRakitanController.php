<?php
namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use App\Models\PcRakitan;

class PcRakitanController extends Controller {
    public function index() {
        return response()->json(PcRakitan::all());
    }
}