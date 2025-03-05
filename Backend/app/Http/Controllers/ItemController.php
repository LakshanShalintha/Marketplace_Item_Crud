<?php

namespace App\Http\Controllers;

use App\Models\Item;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    // Get all items
    public function index()
    {
        return response()->json(Item::all(), 200);
    }

    // Store a new item
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'price' => 'required|numeric',
            'description' => 'required|string',
            'image_url' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048' 
        ]);
    
        // Check if the image is uploaded
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            
            // Ensure the file is valid
            if ($image->isValid()) {
                $imagePath = $image->store('uploads', 'public'); 
            } else {
                return response()->json(['error' => 'Invalid image file'], 400);
            }
        } else {
            $imagePath = null;
        }
        
        $item = Item::create([
            'title' => $request->title,
            'price' => $request->price,
            'description' => $request->description,
            'image_url' => $imagePath,  // Save the image path (URL) in the database
        ]);
    
        return response()->json($item, 201);
    }
    

    // Get a single item
    public function show($id)
    {
        $item = Item::find($id);
        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }
        return response()->json($item, 200);
    }

    // Update an item
    public function update(Request $request, $id)
    {
        $item = Item::find($id);
        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }

        $item->update($request->all());
        return response()->json($item, 200);
    }

    // Delete an item
    public function destroy($id)
    {
        $item = Item::find($id);
        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
        }

        $item->delete();
        return response()->json(['message' => 'Item deleted'], 200);
    }
}
